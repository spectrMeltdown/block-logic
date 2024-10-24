import 'dart:async';

import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_room.g.dart';

@riverpod
Stream<Room?> selectedRoom(
  Ref ref,
  String roomID, {
  bool futureOnly = false,
}) async* {
  final db = FirebaseDatabase.instance;
  final ref = db.ref('rooms/$roomID');
  if (futureOnly) {
    yield Room.fromRTDB(await ref.get());
  } else {
    final controller = StreamController<Room?>();
    ref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        controller.add(Room.fromRTDB(snapshot));
      } else {
        controller.add(null);
      }
    });
    yield* controller.stream;
  }
}
