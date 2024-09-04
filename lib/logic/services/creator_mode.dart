import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/creator_mode.g.dart';

@riverpod
class CreatorModeManager extends _$CreatorModeManager {
  Future<String?> addRoom(Room room) async {
    try {
      await state._rooms.doc().set(room.toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  @override
  CreatorModeState build() {
    final errorHander = ref.read(errorHandlerProvider.notifier);
    return CreatorModeState(errorHandler: errorHander);
  }

  Future<String?> deleteRoom(String roomID) async {
    try {
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> editRoom(Room room) async {
    if (room.id == null || room.id!.isEmpty) {
      throw ('Room id must not be empty!');
    }
    try {
      await state._rooms.doc(room.id).update(room.toFirestore());
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

  CreatorModeState({required ErrorHandler errorHandler}) : _errorHandler = errorHandler;
}
