import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/error_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
      await state._db.push().set(room.toJSON());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<bool> joinRoom(String roomID) async {
    try {
      final result = await state._db.child('$roomID/players').runTransaction((obj) {
        final players = (obj as Map<Object?, Object?>?)?.map((k, v) => MapEntry(k as String, v as bool));
        if (players == null || players.isEmpty) {
          return Transaction.success({state._auth.uid: true});
        }
        players.addAll({state._auth.uid: true});
        return Transaction.success(players);
      });
      if (result.committed) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(state._errorHandler.call(e, this));
      return false;
    }
  }

  Future<String?> leaveRoom(String roomID) async {
    try {
      final result = await state._db.child('$roomID/players').runTransaction((obj) {
        var players = (obj as Map<Object?, Object?>?)?.map((k, v) => MapEntry<String, Object?>(k as String, v as bool)).cast<String, Object?>();
        if (players == null || players.isEmpty) {
          return Transaction.abort();
        }
        players.removeWhere((k, v) => k == state._auth.uid);
        return Transaction.success(players);
      });
      if (result.committed) {
        return null;
      }
      return 'Error leaving the room. Please try again.';
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<Map<String, bool>?> currentPlayers(String roomID) async {
    try {
      final doc = await state._db.child(roomID).get();
      return Room.fromRTDB(doc).players ?? {};
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
      final lockedRoom = room.copyWith(status: RoomStatus.locked);
      await state._db.child(room.id!).runTransaction((obj) {
        final status = Room.fromRTDB(obj).status;
        if (status != null && status == RoomStatus.locked) {
          return Transaction.success(lockedRoom.toJSON());
        }
        if (status != null && status == RoomStatus.available) {
          return Transaction.success(room.toJSON());
        }
        return Transaction.abort();
      });
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
      final result = await state._db.child('$roomID/players').runTransaction((obj) {
        var players = (obj as Map<Object?, Object?>?)?.map((k, v) => MapEntry<String, Object?>(k as String, v as bool)).cast<String, Object?>();
        if (players == null || players.isEmpty) {
          return Transaction.abort();
        }
        final modifiedPlayers = removeAll ? {} : Map.from(players);
        for (final uid in selectedIDs) {
          modifiedPlayers.removeWhere((k, v) => k == uid);
        }
        return Transaction.success(modifiedPlayers);
      });
      if (result.committed) {
        return null;
      }
      return 'No players found!';
      // final room = Room.fromRTDB(await state._db.child(roomID).get());
      // if (room.players != null) {
      //   // if same length meaning remove all players
      //   if (room.players!.length == selectedIDs.length || removeAll) {
      //     await state._db.child(roomID).update({'players': [], 'status': 'available'});
      //   } else {
      //     final List<String> listToRemove = [];
      //     for (final item in selectedIDs) {
      //       listToRemove.add(room.players!.firstWhere((i) => i == item));
      //     }
      //     await state._db.child(roomID).update({'players': listToRemove});
      //   }
      // } else {
      //   return 'No players found!';
      // }
      // return null;
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
