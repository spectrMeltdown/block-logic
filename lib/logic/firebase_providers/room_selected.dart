import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_selected.g.dart';

@Riverpod(dependencies: [])
Stream<List<Room>> ownRooms(OwnRoomsRef ref, String accountID) async* {
  final db = FirebaseFirestore.instance;
  final ownRoomsStream =
      db.collection('rooms').where('hostID', isEqualTo: accountID).snapshots();
  await for (final ownRooms in ownRoomsStream) {
    final List<Room> result = [];
    if (ownRooms.docs.isNotEmpty) {
      for (final room in ownRooms.docs) {
        result.add(Room.fromFirestore(room));
      }
    }
    yield result;
  }
}
