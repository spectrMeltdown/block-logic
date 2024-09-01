import 'package:block_logic/logic/services/error_handler.dart';
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
}

class LeaderboardManagerState {
  final ErrorHandler _errorHandler;
  //final AccountService _accountService;

  LeaderboardManagerState({
    required ErrorHandler errorHandler,
    // required AccountService accountService,
  }) : _errorHandler = errorHandler
  //   _accountService = accountService
  ;
}
