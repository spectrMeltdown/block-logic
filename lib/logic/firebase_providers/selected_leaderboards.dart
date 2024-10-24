import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_leaderboards.g.dart';

/// returns leaderboard under a given room
@riverpod
Stream<List<Leaderboard>?> selectedLeaderboards(Ref ref, String roomID) async* {
  if (roomID.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('leaderboards').orderByChild('roomID').equalTo(roomID).onValue;
    await for (final query in stream) {
      List<Leaderboard> result = [];
      if (query.snapshot.children.isNotEmpty) {
        for (final leaderboard in query.snapshot.children) {
          result.add(Leaderboard.fromRTDB(leaderboard));
        }
      }
      // result = result.where((i) => i.players!.contains(roomID)).toList();
      yield result;
    }
  }
}
