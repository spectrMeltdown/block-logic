import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/selected_leaderboard.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/leaderboard/selected_leaderboard.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinalizingResults extends ConsumerStatefulWidget {
  final String leaderboardID;
  const FinalizingResults(this.leaderboardID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinalizingResultsState();
}

class _FinalizingResultsState extends ConsumerState<FinalizingResults> {
  late final GameManager manager;
  late final CustomNavigation nav;
  String leaderboardID = '';
  final loading = const BLLoading(
    message: 'Loading leaderboard ...',
  );
  late final Widget errorWidget;

  @override
  void initState() {
    manager = ref.read(gameManagerProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    leave();
    errorWidget = Column(
      children: [
        const BLError(
          message: 'Error loading the leaderboard.',
        ),
        const SizedBox(
          height: 20,
        ),
        BLButton(onPressed: () => nav.pushAndRemove(context, const MainMenuScreen()), child: const BLText('Return to Main Menu'))
      ],
    );
    super.initState();
  }

  void leave() async {
    await manager.leaveGame(true);
    setState(() {
      leaderboardID = manager.getLeaderboardID();
    });
  }

  @override
  void dispose() {
    // manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaderboard = ref.watch(SelectedLeaderboardProvider(leaderboardID));
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Background(
          child: SafeArea(
            child: leaderboard.when(
              data: (leaderboard) {
                if (leaderboardID.isEmpty) {
                  return loading;
                }
                if (leaderboard == null) {
                  return errorWidget;
                }
                return SelectedLeaderboard(
                  leaderboard,
                  showBackButton: false,
                  // roomTitle: widget.room.name!,
                );
              },
              error: (error, stackTrace) {
                genericError(error, stackTrace);
                return errorWidget;
              },
              loading: () {
                genericLoading();
                return loading;
              },
            ),
          ),
        ),
      ),
    );
  }
}
