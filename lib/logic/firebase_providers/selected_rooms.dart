import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_rooms.g.dart';

@riverpod
Stream<List<Room>> selectedRooms(
  SelectedRoomsRef ref,
  String accountID,
) async* {
  if (accountID.isNotEmpty) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('rooms').where('hostID', isEqualTo: accountID).snapshots();
    await for (final query in stream) {
      final List<Room> result = [];
      if (query.docs.isNotEmpty) {
        for (final room in query.docs) {
          result.add(Room.fromFirestore(room));
        }
      }

      /// remove rooms marked with admin lock
      result.removeWhere((room) {
        return room.adminLocked == true;
      });
      yield result;
    }
  }
}
