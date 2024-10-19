import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/services/error_handler.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/score_manager.g.dart';

@riverpod
class ScoreManager extends _$ScoreManager {
  @override
  ScoreManagerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return ScoreManagerState(errorHandler: errorHandler);
  }

  Future<String?> create(String leaderboardID, Score score) async {
    if (leaderboardID.isEmpty) throw ('Must provide leaderboard id!');
    try {
      await state._db.child('$leaderboardID/scores/${FirebaseAuth.instance.currentUser!.uid}').set(score.toJSON());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> update(String leaderboardID, Score score) async {
    if (score.id == null || score.id!.isEmpty) throw ('Score id not provided.');
    try {
      await state._db.child('$leaderboardID/scores/${score.id}').update(score.toJSON());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> increment({
    required String leaderboardID,
    required String uid,
    required int value,
  }) async {
    if (leaderboardID.isEmpty || uid.isEmpty) throw ('Either leaderboardID or UID was blank.');
    try {
      dPrint('Incrementing on $leaderboardID $uid $value');
      await state._db.child('$leaderboardID/scores/$uid').update({
        'playerScore': value,
      });
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class ScoreManagerState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseDatabase.instance.ref('leaderboards');
  ScoreManagerState({required ErrorHandler errorHandler}) : _errorHandler = errorHandler;
}
