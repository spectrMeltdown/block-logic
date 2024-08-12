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
  final roomStream = db.collection('rooms').doc(roomID).snapshots();
  await for (final room in roomStream) {
    if (room.exists) {
      yield Room.fromFirestore(room);
    }
    yield null;
  }
}
