import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_manager.g.dart';

@riverpod
class RoomManager extends _$RoomManager {
  @override
  RoomManagerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final encryption = ref.read(encryptionProvider.notifier);
    return RoomManagerState(errorHandler, encryption);
  }

  Future<String?> create(Room room) async {
    try {
      await state._db.doc().set(room.toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<bool> joinRoom(String roomID) async {
    try {
      await state._db.doc(roomID).update({
        'players': FieldValue.arrayUnion([state._auth.uid]),
      });
      return true;
    } catch (e) {
      debugPrint(state._errorHandler.call(e, this));
      return false;
    }
  }

  Future<String?> leaveRoom(String roomID) async {
    try {
      await state._db.doc(roomID).update({
        'players': FieldValue.arrayRemove([state._auth.uid])
      });
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<List<String>?> currentPlayers(String roomID) async {
    try {
      final doc = await state._db.doc(roomID).get();
      return Room.fromFirestore(doc).players ?? [];
    } catch (e) {
      return [state._errorHandler.call(e, this) ?? 'error'];
    }
  }

  Future<String?> update(Room room) async {
    if (room.id == null) {
      throw ('You must provide a room id for update()');
    }
    try {
      await state._db.doc(room.id!).update(room.toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<bool> validatePassword({
    required String input,
    required String pass,
    required String hostID,
  }) async {
    return input == state._encryption.decryptString(encrypted: pass, key: hostID);
  }
}

class RoomManagerState {
  final ErrorHandler _errorHandler;
  final Encryption _encryption;
  final _db = FirebaseFirestore.instance.collection('rooms');
  final _auth = FirebaseAuth.instance.currentUser!;

  RoomManagerState(this._errorHandler, this._encryption);
}
