import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/creator_mode.g.dart';

@riverpod
class CreatorModeManager extends _$CreatorModeManager {
  Future<String?> addRoom(Room room) async {
    String? encryptedPass;
    if (room.password != null && room.password!.isNotEmpty) {
      if (room.hostID == null || room.hostID!.isEmpty) throw ('Password was provided, but hostID was null!');
      encryptedPass = state._encryption.encryptString(text: room.password!, key: room.hostID!);
    }
    try {
      await state._rooms.doc().set(room.copyWith(password: encryptedPass!).toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  @override
  CreatorModeState build() {
    final errorHander = ref.read(errorHandlerProvider.notifier);
    final encryption = ref.read(encryptionProvider.notifier);
    return CreatorModeState(errorHandler: errorHander, encryption: encryption);
  }

  Future<String?> deleteRoom(String roomID) async {
    if (roomID.isEmpty) {
      throw ('Room id must not be empty!');
    }
    try {
      await state._rooms.doc(roomID).delete();
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> editRoom(Room room) async {
    if (room.id == null || room.id!.isEmpty) {
      throw ('Room id must not be empty!');
    }
    String? encryptedPass;
    if (room.password != null && room.password!.isNotEmpty) {
      if (room.hostID == null || room.hostID!.isEmpty) throw ('Password was provided, but hostID was null!');
      encryptedPass = state._encryption.encryptString(text: room.password!, key: room.hostID!);
    }
    try {
      await state._rooms.doc(room.id).update(room.copyWith(password: encryptedPass!).toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class CreatorModeState {
  final _rooms = FirebaseFirestore.instance.collection('rooms');
  final _user = FirebaseAuth.instance.currentUser;
  final ErrorHandler _errorHandler;
  final Encryption _encryption;

  CreatorModeState({required ErrorHandler errorHandler, required Encryption encryption})
      : _errorHandler = errorHandler,
        _encryption = encryption;
}
