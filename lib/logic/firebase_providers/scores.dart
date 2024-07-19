import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/scores.g.dart';

/// stream all scores under a specific leaderboardID
@Riverpod(dependencies: [])
Stream<List<Score>> scores(ScoresRef ref, String leaderboardID) async* {
  final db = ref.watch(dbProvider).i;
  final stream = db
      .collection('leaderboards')
      .doc(leaderboardID)
      .collection('scores')
      .snapshots();

  await for (final snapshot in stream) {
    List<Score> result = [];
    if (snapshot.docs.isNotEmpty) {
      for (final score in snapshot.docs) {
        result.add(Score.fromFirestore(score));
      }
    }
    yield result;
  }
}
