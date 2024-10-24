import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/scores.g.dart';

/// stream all scores under a specific leaderboardID
@riverpod
Stream<List<Score>> scores(Ref ref, String leaderboardID) async* {
  final db = FirebaseDatabase.instance;
  final stream = db.ref('leaderboards/$leaderboardID/scores').onValue;
  await for (final query in stream) {
    List<Score> result = [];
    if (query.snapshot.children.isNotEmpty) {
      for (final score in query.snapshot.children) {
        result.add(Score.fromRTDB(score));
      }
    }
    yield result;
  }
}
