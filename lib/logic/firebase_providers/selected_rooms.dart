import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_rooms.g.dart';

@riverpod
Stream<List<Room>> selectedRooms(
  SelectedRoomsRef ref,
  String accountID,
) async* {
  await for (final auth in FirebaseAuth.instance.authStateChanges()) {
    if (auth != null && accountID.isNotEmpty) {
      final db = FirebaseFirestore.instance;
      final ownRoomsStream = db.collection('rooms').where('hostID', isEqualTo: accountID).snapshots();
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
  }
}
