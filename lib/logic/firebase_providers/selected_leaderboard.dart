import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_leaderboard.g.dart';

@riverpod
Stream<Leaderboard?> selectedLeaderboard(SelectedLeaderboardRef ref, String leaderboardID) async* {
  if (leaderboardID.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('leaderboards/$leaderboardID').onValue;
    await for (final doc in stream) {
      if (doc.snapshot.exists) {
        yield Leaderboard.fromRTDB(doc.snapshot);
      }
    }
  } else {
    yield null;
  }
}
