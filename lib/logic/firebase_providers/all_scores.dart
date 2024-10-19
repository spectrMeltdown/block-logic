import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_scores.g.dart';

@riverpod
Stream<Map<ScoreStatus, List<Score>>?> allScores(AllScoresRef ref, String leaderboardID) async* {
  if (leaderboardID.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('leaderboards/$leaderboardID/scores').onValue;
    await for (final query in stream) {
      final Map<ScoreStatus, List<Score>> result = {
        ScoreStatus.complete: [],
        ScoreStatus.incomplete: [],
        ScoreStatus.pending: [],
      };
      final List<Score> scores = [];
      if (query.snapshot.children.isNotEmpty) {
        /// convert doc to score
        for (final doc in query.snapshot.children) {
          scores.add(Score.fromRTDB(doc));
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
        }

        /// do a ranking on ScoreStatus.complete
        if (result[ScoreStatus.complete]!.isNotEmpty) {
          /// sort time elapsed
          result[ScoreStatus.complete]!.sort((a, b) {
            if (b.playerScore != a.playerScore) {
              // Primary sort by score (higher score first)
              return b.playerScore!.compareTo(a.playerScore!);
            } else {
              // Secondary sort by timeElapsed (lower time first)
              return DateTime.fromMillisecondsSinceEpoch(a.timeElapsed!).compareTo(DateTime.fromMillisecondsSinceEpoch(b.timeElapsed!));
            }
          });
        }
      }

      for (final scores in result.entries) {
        // dPrint(score.key.toString());
        for (final score in scores.value) {
          dPrint(score.playerScore.toString());
          dPrint(score.status.toString());
        }
      }
      yield result;
    }
  }
  yield null;
}
