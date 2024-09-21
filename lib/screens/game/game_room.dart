import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenges.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/screens/game/finalizing_results.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:block_logic/screens/game/pause_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRoom extends ConsumerStatefulWidget {
  final Room room;
  const GameRoom(this.room, {super.key});

  @override
  ConsumerState<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends ConsumerState<GameRoom> with WidgetsBindingObserver {
  late final GameManager gameManager;
  late final CustomNavigation nav;
  // late final AsyncValue<List<Challenge>> challenges;
  late final DialogService dialog;
  late final RoomManager roomManager;
  int currentChallenge = 0;
  int? challengeLength;
  @override
  Widget build(BuildContext context) {
    // this is a Future, but it is set to ref.watch because read will return first value only, which may still be a loading/error state
    final challenges = ref.watch(SelectedChallengesProvider(widget.room.challengeIDs!));
    if (challengeLength != null && currentChallenge == challengeLength) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nav.pushReplace(context, FinalizingResults(widget.room.currentLeaderboardID!));
      });
      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
        child: const Scaffold(
          body: Background(child: SafeArea(child: BLLoading())),
        ),
      );
      // Future.delayed(Duration.zero, () async {

      // });

      // return Scaffold(
      //   body: Background(
      //     child: FutureBuilder(
      //         // future: finalizeGame(),
      //         future: gameManager.leaveGame(true),
      //         initialData: '',
      //         builder: (context, snapshot) {
      //           // if (snapshot.connectionState == ConnectionState.waiting) {
      //           //   return Center(
      //           //       child: BLLoading(
      //           //     message: 'Loading leaderboard ..',
      //           //   ));
      //           // }
      //           // if (snapshot.hasError) {
      //           //   debugPrint(snapshot.error.toString());
      //           //   return const BLText('Error!');
      //           // }
      //           final leaderboard = ref.watch(SelectedLeaderboardProvider(gameManager.getLeaderboardID()));
      //           return leaderboard.when(
      //               data: (leaderboard) {
      //                 if (leaderboard == null) {
      //                   return const BLText('Couldn\'t load the leaderboard ...');
      //                 }
      //               },
      //               error: genericError,
      //               loading: genericLoading);
      //         }),
      //   ),
      // );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final leave = await dialog.show(context, const PauseDialog());
        if (leave is bool && leave) {
          if (!context.mounted) return;
          final result = await showDialog(context: context, builder: (context) => const ConfirmDialog());
          if (result is bool && result) {
            await gameManager.leaveGame(false);
            if (!context.mounted) return;
            nav.pop(context);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
          child: SafeArea(
            child: challenges.when(
                data: (challenges) {
                  if (challenges.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: BLText('Sorry, there is a problem getting the challenges ...', softWrap: true),
                      ),
                    );
                  }
                  challengeLength ??= challenges.length;
                  // debugPrint('Challenge length: $challengeLength');
                  // debugPrint('current challenge: $currentChallenge');
                  return GameChallenge(
                    currentChallenge: 0,
                    roomName: widget.room.name ?? '',
                    challenge: challenges[currentChallenge],
                    challengeCount: challenges.length,
                    updateChallenge: updateChallenge,
                  );
                },
                error: genericError,
                loading: genericLoading),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    gameManager.init(widget.room);
    roomManager = ref.read(roomManagerProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    nav = ref.read(customNavigationProvider);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    /// this code runs whenever the user closes the app without properly exiting the game.
    if (state == AppLifecycleState.detached) {
      await gameManager.leaveGame(false);
    }
  }

  void updateChallenge() {
    setState(() {
      currentChallenge++;
    });
  }

  // Future<String?> finalizeGame() async {
  //   await ;
  // }
}
