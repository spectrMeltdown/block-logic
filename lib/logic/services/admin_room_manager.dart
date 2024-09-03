import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/admin_room_manager.g.dart';

@riverpod
class AdminRoomManager extends _$AdminRoomManager {
  ErrorHandler? _errorHandler;
  final _db = FirebaseFirestore.instance;
  @override
  void build() {
    _errorHandler = ref.read(errorHandlerProvider.notifier);
  }

  Future<String?> delete(String roomID) async {
    if (roomID.isEmpty) return 'RoomID was blank';
    final roomRef = _db.collection('rooms').doc(roomID);
    try {
      final doc = await roomRef.get();
      if (doc.exists) {
        final room = Room.fromFirestore(doc);

        /// if the room is admin locked, and players have left the room, then the room can be safely deleted.
        if (room.adminLocked != null && room.adminLocked == true) {
          if (room.players != null && room.players!.isEmpty) {
            await roomRef.delete();
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
      return _errorHandler?.call(e);
    }
  }

  Future<String?> setLock(String roomID, bool newLockState) async {
    if (roomID.isEmpty) return 'RoomID was blank';
    final roomRef = _db.collection('rooms').doc(roomID);
    try {
      final room = await roomRef.get();
      if (room.exists) {
        final roomData =
            Room(adminLocked: newLockState, status: newLockState == true ? RoomStatus.locked : RoomStatus.available);
        await roomRef.update(roomData.toFirestore());
      } else {
        return 'Room doesn\'t exist';
      }
      return null;
    } catch (e) {
      return _errorHandler?.call(e);
    }
  }
}
