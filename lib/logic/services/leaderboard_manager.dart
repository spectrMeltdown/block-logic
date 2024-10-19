import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';

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

  Future<String?> create(Leaderboard leaderboard) async {
    if (leaderboard.id == null || leaderboard.id!.isEmpty) return '';
    try {
      final ref = state._db.child(leaderboard.id!);
      await ref.set(leaderboard.toJSON());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  // Stream<String?> isLeaderboardCreated(String leaderboardID) async* {
  //   if (leaderboardID.isNotEmpty) {
  //     final stream = state._db.child(leaderboardID).onValue;
  //     await for (final query in stream) {
  //       if (query.exists) {
  //         yield null;
  //       }
  //     }
  //   } else {
  //     yield 'leaderboardID was blank';
  //   }
  // }

  Future<String?> update(Leaderboard leaderboard) async {
    if (leaderboard.id == null || leaderboard.id!.isEmpty) return 'ID not provided';
    try {
      // dPrint(leaderboard.id);
      await state._db.child(leaderboard.id!).runTransaction((obj) {
        final lb = Leaderboard.fromRTDB(obj, leaderboard.id);
        if (lb.id!.isNotEmpty && (lb.status != null || lb.status != LeaderboardStatus.complete)) {
          dPrint('transaction success');
          return Transaction.success(lb.copyWith(status: LeaderboardStatus.complete, players: null).toJSON());
        }
        dPrint('transaction abort');
        return Transaction.abort();
      });
      // if (result.committed) {
      // } else {
      //   dPrint('NOT COMMIITED');
      // }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> updatePlayers(String leaderboardID, Map<String, dynamic> players) async {
    final ref = state._db.child(leaderboardID);
    try {
      await ref.update({'players': players.keys.toList()});
      final leaderboard = Leaderboard.fromRTDB(await ref.get());
      if (leaderboard.players!.isEmpty) {
        ref.remove();
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class LeaderboardManagerState {
  final ErrorHandler _errorHandler;
  final _db = FirebaseDatabase.instance.ref('leaderboards');
  //final AccountService _accountService;

  LeaderboardManagerState({
    required ErrorHandler errorHandler,
    // required AccountService accountService,
  }) : _errorHandler = errorHandler
  //   _accountService = accountService
  ;
}
