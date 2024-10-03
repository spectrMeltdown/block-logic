import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/admin_room_manager.g.dart';

@riverpod
class AdminRoomManager extends _$AdminRoomManager {
  ErrorHandler? _errorHandler;
  final _db = FirebaseDatabase.instance;
  @override
  void build() {
    _errorHandler = ref.read(errorHandlerProvider.notifier);
  }

  Future<String?> delete(String roomID) async {
    if (roomID.isEmpty) return 'RoomID was blank';
    final roomRef = _db.ref('rooms').child(roomID);
    try {
      final doc = await roomRef.get();
      if (doc.exists) {
        final room = Room.fromRTDB(doc);

        /// if the room is admin locked, and players have left the room, then the room can be safely deleted.
        if (room.adminLocked != null && room.adminLocked == true) {
          if (room.players != null && room.players!.isEmpty) {
            await roomRef.remove();
          } else {
            return 'Room is locked, but still currently has players.';
          }
        } else {
          return 'Room is not locked yet.';
        }
      } else {
        return 'Room doesn\'t exist.';
      }
      return null;
    } catch (e) {
      return _errorHandler?.call(e, this);
    }
  }

  Future<String?> setLock(String roomID, bool newLockState) async {
    if (roomID.isEmpty) return 'RoomID was blank';
    final roomRef = _db.ref('rooms').child(roomID);
    try {
      final room = await roomRef.get();
      if (room.exists) {
        final roomData = Room(
          adminLocked: newLockState,
          status: newLockState == true ? RoomStatus.locked : RoomStatus.available,
        );
        await roomRef.update(roomData.toJSON());
      } else {
        return 'Room doesn\'t exist';
      }
      return null;
    } catch (e) {
      return _errorHandler?.call(e, this);
    }
  }
}
