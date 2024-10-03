import 'dart:convert';

import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/error_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
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
      await state._db.push().set(room.toJSON());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<bool> joinRoom(String roomID) async {
    try {
      final players = await state._db.child(roomID).get().then((value) => Room.fromRTDB(value).players);
      players!.add(state._auth.uid);
      await state._db.child(roomID).update({
        'players': players,
      });
      return true;
    } catch (e) {
      debugPrint(state._errorHandler.call(e, this));
      return false;
    }
  }

  Future<String?> leaveRoom(String roomID) async {
    try {
      final players = await state._db.child(roomID).get().then((value) => Room.fromRTDB(value).players);
      players!.removeWhere((i) => i == state._auth.uid);
      await state._db.child(roomID).update({'players': players});
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<List<String>?> currentPlayers(String roomID) async {
    try {
      final doc = await state._db.child(roomID).get();
      return Room.fromRTDB(doc).players ?? [];
    } catch (e) {
      debugPrint(state._errorHandler.call(e, this) ?? '');
      return null;
    }
  }

  Future<String?> update(Room room) async {
    if (room.id == null) {
      throw ('You must provide a room id!');
    }
    try {
      // if adminlocked, don't overwrite it
      final adminLocked = Room.fromRTDB(await state._db.child(room.id!).get()).adminLocked;
      if (adminLocked!) {
        final newRoom = room.copyWith(status: RoomStatus.locked);
        await state._db.child(newRoom.id!).update(newRoom.toJSON());
      } else {
        await state._db.child(room.id!).update(room.toJSON());
      }
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

  Future<String?> removePlayers(String roomID, List<String> selectedIDs, {bool removeAll = false}) async {
    if (roomID.isEmpty) throw ('Room ID was blank!');
    try {
      final response = await http.post(
        Uri.parse('$blockLogic/remove-players'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'players': selectedIDs,
          'removeAll': removeAll,
        }),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return body['message'];
      } else {
        return body['error'];
      }
    } catch (e) {
      return state._errorHandler.call(e, this) ?? 'error';
    }
  }
}

class RoomManagerState {
  final ErrorHandler _errorHandler;
  final Encryption _encryption;
  final _db = FirebaseDatabase.instance.ref('rooms');
  final _auth = FirebaseAuth.instance.currentUser!;

  RoomManagerState(this._errorHandler, this._encryption);
}
