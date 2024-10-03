import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_room.g.dart';

@riverpod
Stream<Room?> selectedRoom(
  SelectedRoomRef ref,
  String roomID, {
  bool futureOnly = false,
}) async* {
  final db = FirebaseDatabase.instance;
  final ref = db.ref('rooms/$roomID');
  if (futureOnly) {
    yield Room.fromRTDB(await ref.get());
  } else {
    final stream = ref.onValue;
    await for (final doc in stream) {
      if (doc.snapshot.exists) {
        yield Room.fromRTDB(doc.snapshot);
      } else {
        yield null;
      }
    }
  }
}
