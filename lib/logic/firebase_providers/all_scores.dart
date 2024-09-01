import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_scores.g.dart';

@riverpod
Stream<Map<ScoreStatus, List<Score>>?> allScores(AllScoresRef ref, String leaderboardID) async* {
  if (leaderboardID.isNotEmpty) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('leaderboards').doc(leaderboardID).collection('scores').snapshots();
    await for (final query in stream) {
      final Map<ScoreStatus, List<Score>> result = {
        ScoreStatus.complete: [],
        ScoreStatus.incomplete: [],
        ScoreStatus.pending: [],
      };
      final List<Score> scores = [];
      if (query.docs.isEmpty) {
        /// convert doc to score
        for (final doc in query.docs) {
          scores.add(Score.fromFirestore(doc));
        }

        /// loop through scores
        for (final score in scores) {
          /// assign to proper category
          switch (score.status) {
            case ScoreStatus.pending:
              result[ScoreStatus.pending]!.add(score);
              break;
            case ScoreStatus.incomplete:
              result[ScoreStatus.incomplete]!.add(score);
              break;
            case ScoreStatus.complete:
              result[ScoreStatus.complete]!.add(score);
              break;
            default:
          }

          /// do a ranking on ScoreStatus.complete
          if (result[ScoreStatus.complete]!.isNotEmpty) {
            /// sort score first
            result[ScoreStatus.complete]!.sort((a, b) => a.playerScore!.compareTo(b.playerScore!));

            /// sort time elapsed
            result[ScoreStatus.complete]!.sort((a, b) => a.timeElapsed!.compareTo(b.timeElapsed!));
          }
        }
      }
      yield result;
    }
  }
}
