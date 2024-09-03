import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_room.g.dart';

@riverpod
Stream<Room?> selectedRoom(
  SelectedRoomRef ref,
  String roomID,
) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('rooms').doc(roomID).snapshots();
  await for (final doc in stream) {
    if (doc.exists) {
      yield Room.fromFirestore(doc);
    } else {
      yield null;
    }
  }
}
