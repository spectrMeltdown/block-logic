import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/firebase_providers/selected_leaderboard.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/screens/leaderboard/selected_leaderboard.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flame_audio/flame_audio.dart';
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
  late String leaderboardID;
  final loading = const BLLoading(
    message: 'Loading leaderboard ...',
  );
  late final Widget errorWidget;

  @override
  void initState() {
    super.initState();
    manager = ref.read(gameManagerProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    final assets = ref.read(assetsProvider);
    final sharedPref = ref.read(sharedPrefProvider);

    /// check if a backgroundMusic setting exists
    final backgroundMusic = sharedPref.getBool('backgroundMusic');
    if (backgroundMusic == null || backgroundMusic == true) {
      /// initialize the audio
      FlameAudio.bgm.play(assets.audioBG1);
    } else {
      /// play silently to load the track
      FlameAudio.bgm.play(assets.audioBG1, volume: 0);

      /// pause after track loaded
      FlameAudio.bgm.pause();
    }
    errorWidget = Column(
      children: [
        const BLError(
          message: 'Error loading the leaderboard.',
        ),
        const SizedBox(
          height: 20,
        ),
        BLButton(
          onPressed: () => nav.pushAndRemove(context, const MainMenuScreen()),
          child: const BLText('Return to Main Menu'),
        )
      ],
    );
    leaderboardID = manager.getLeaderboardID();
    leave();
  }

  Future<void> leave() async {
    final result = await manager.leaveGame(true);
    if (result != null) {
      dPrint('Leave result is: $result');
    } else {
      dPrint('Leave Room success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaderboard = ref.watch(SelectedLeaderboardProvider(leaderboardID));
    return PopScope(
      canPop: false,
      child: leaderboard.when(
        data: (leaderboard) {
          if (leaderboardID.isEmpty) {
            return loading;
          }
          if (leaderboard == null) {
            return errorWidget;
          }
          Future.microtask(() {
            if (context.mounted) {
              nav.pushReplace(
                  context,
                  SelectedLeaderboard(
                    leaderboard,
                    showBackButton: false,
                    // roomTitle: widget.room.name!,
                  ));
            }
          });
          return Scaffold(
            body: Background(child: loading),
          );
        },
        error: (error, stackTrace) {
          genericError(error, stackTrace);
          return Scaffold(
            body: Background(child: errorWidget),
          );
        },
        loading: () {
          genericLoading();
          return Scaffold(
            body: Background(child: loading),
          );
        },
      ),
    );
  }
}
