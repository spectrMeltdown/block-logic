import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/scores.g.dart';

/// stream all scores under a specific leaderboardID
@Riverpod(dependencies: [])
Stream<List<Score>> scores(ScoresRef ref, String leaderboardID) async* {
  final db = FirebaseFirestore.instance;
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
