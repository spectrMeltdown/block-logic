import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_leaderboards.g.dart';

@riverpod
Stream<List<Leaderboard>> leaderboards(LeaderboardsRef ref) async* {
  final db = FirebaseDatabase.instance;
  final leaderboardsStream = db.ref('leaderboards').onValue;
  await for (final leaderboards in leaderboardsStream) {
    final List<Leaderboard> result = [];
    if (leaderboards.snapshot.children.isNotEmpty) {
      for (final leaderboard in leaderboards.snapshot.children) {
        result.add(Leaderboard.fromRTDB(leaderboard));
      }
    }
    yield result;
  }
}
