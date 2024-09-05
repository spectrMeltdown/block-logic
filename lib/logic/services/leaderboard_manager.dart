import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/leaderboard_manager.g.dart';

@riverpod
class LeaderboardManager extends _$LeaderboardManager {
  @override
  LeaderboardManagerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    //final accountService = ref.read(accountServiceProvider.notifier);
    return LeaderboardManagerState(
      errorHandler: errorHandler,
      //accountService: accountService,
    );
  }

  Future<String?> create(Leaderboard leaderboard, [bool returnID = false]) async {
    if (leaderboard.id == null || leaderboard.id!.isEmpty) return '';
    try {
      final ref = state._db.doc(leaderboard.id);
      await ref.set(leaderboard.toFirestore());
      final doc = await ref.get();
      if (returnID) {
        return Leaderboard.fromFirestore(doc).id;
      }
      return null;
    } catch (e) {
      if (returnID) {
        return 'error';
      }
      return state._errorHandler.call(e, this);
    }
  }

  Stream<String?> isLeaderboardCreated(String leaderboardID) async* {
    if (leaderboardID.isNotEmpty) {
      final stream = state._db.doc(leaderboardID).snapshots();
      await for (final query in stream) {
        if (query.exists) {
          yield null;
        }
      }
    } else {
      yield 'leaderboardID was blank';
    }
  }

  Future<String?> update(Leaderboard leaderboard) async {
    if (leaderboard.id == null || leaderboard.id!.isEmpty) return 'ID not provided';
    try {
      await state._db.doc(leaderboard.id).set(leaderboard.toFirestore(), SetOptions(merge: true));
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> updatePlayers(String leaderboardID, Map<String, dynamic> players) async {
    try {
      await state._db.doc(leaderboardID).set(players, SetOptions(merge: true));
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class LeaderboardManagerState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseFirestore.instance.collection('leaderboards');
  //final AccountService _accountService;

  LeaderboardManagerState({
    required ErrorHandler errorHandler,
    // required AccountService accountService,
  }) : _errorHandler = errorHandler
  //   _accountService = accountService
  ;
}
