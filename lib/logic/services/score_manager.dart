import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    try {
      final doc = await state._db.doc(leaderboardID).get();
      if (doc.exists) {
        return 'Cannot create, score already exists.';
      }
      await state._db.doc(leaderboardID).set(score.toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> update(String leaderboardID, Score score) async {
    if (score.id == null || score.id!.isEmpty) return 'Score id not provided.';
    try {
      final doc = await state._db.doc(leaderboardID).get();
      if (doc.exists) {
        return 'Cannot create, score already exists.';
      }
      await state._db.doc(leaderboardID).update(score.toFirestore());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class ScoreManagerState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseFirestore.instance.collection('leaderboards');
  ScoreManagerState({required ErrorHandler errorHandler}) : _errorHandler = errorHandler;
}
