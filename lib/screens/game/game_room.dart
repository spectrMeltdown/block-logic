import 'dart:async';

import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenges.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/game/logic/should_reset_all_blocks.dart';
import 'package:block_logic/screens/game/finalizing_results.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:block_logic/screens/game/pause_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRoom extends ConsumerStatefulWidget {
  final Room room;
  const GameRoom(this.room, {super.key});

  @override
  ConsumerState<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends ConsumerState<GameRoom> {
  late final GameManager gameManager;
  late final CustomNavigation nav;
  // late final AsyncValue<List<Challenge>> challenges;
  late final DialogService dialog;
  late final RoomManager roomManager;
  late final StreamSubscription<DatabaseEvent> sub;
  bool processing = false;
  int currentChallenge = 0;
  int? challengeLength;
  bool playerLeft = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> playerLeave() async {
    dPrint('Player leave invoked');
    if (!context.mounted) return;
    if (processing) return;
    processing = true;
    await showDialog(context: context, builder: (context) => DisconnectedDialog());
    gameManager.resetTree();
    // gameManager.setShouldResetAllBlocks(true);
    ref.invalidate(getRootDataProvider);
    ref.invalidate(gameManagerProvider);
    // ref.invalidate(shouldResetAllBlocksProvider);

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
    if (!mounted) return;
    nav.pop(context);
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    // this is a Future, but it is set to ref.watch because read will return first value only, which may still be a loading/error state
    final challenges = ref.watch(SelectedChallengesProvider(widget.room.challengeIDs!));
    final innerProcessing = ref.watch(processingProvider);
    final timeLimitReached = ref.watch(gameManagerProvider.select((e) => e.timeElapsed >= 5));
    dPrint('Time limit (not ran): $timeLimitReached');
    if (playerLeft) {
      dPrint('Player left: $playerLeft');
      Future.delayed(Duration.zero, () {
        playerLeave();
      });
    }

    // if out of challenges, go to finalize result screen
    if (timeLimitReached || challengeLength != null && currentChallenge == challengeLength) {
      dPrint('Time limit: $timeLimitReached');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nav.pushReplace(context, FinalizingResults(widget.room.currentLeaderboardID!));
      });
      return const PopScope(
        canPop: false,
        child: Scaffold(
          body: Background(child: SafeArea(child: BLLoading())),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (processing) return;
        setState(() {
          processing = true;
        });
        final leave = await dialog.show(context, const PauseDialog());
        if (leave is bool && leave) {
          if (!context.mounted) return;
          final result = await showDialog(context: context, builder: (context) => const ConfirmDialog());
          if (result is bool && result) {
            final value = await gameManager.leaveGame(false);
            dPrint(value);
            gameManager.resetTree();
            // gameManager.setShouldResetAllBlocks(true);
            ref.invalidate(getRootDataProvider);
            ref.invalidate(gameManagerProvider);

            // ref.invalidate(shouldResetAllBlocksProvider);

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
            dPrint('REACHED HERE');
            if (!context.mounted) return;
            nav.pop(context);
          }
        }
        setState(() {
          processing = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Background(
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
                      challengeLength ??= challenges.length; // to switch to finalizing result if last challenge
                      // dPrint('Challenge length: $challengeLength');
                      // dPrint('current challenge: $currentChallenge');
                      return GameChallenge(
                        key: ValueKey(challenges[currentChallenge].id),
                        currentChallenge: currentChallenge,
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
            Visibility(
                visible: processing || innerProcessing,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const BLLoading(
                    message: 'Loading ...',
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  void initState() {
    super.initState();
    final db = FirebaseDatabase.instance;
    final roomRef = db.ref('rooms/${widget.room.id}/players/$uid');
    final leaderboardsRef = db.ref('leaderboards/${widget.room.currentLeaderboardID}/scores/$uid');
    leaderboardsRef.onDisconnect().update({'status': ScoreStatus.incomplete.name});
    roomRef.onDisconnect().set(false);
    sub = roomRef.onChildChanged.listen((event) {
      dPrint('listen invoked');
      dPrint(event.snapshot.value.toString());
      final snap = event.snapshot;
      if (snap.exists) {
        final players = Room.fromRTDB(snap.value).players?.entries;
        if (players != null && players.any((e) => e.key == uid && e.value == false)) {
          if (context.mounted) {
            setState(() {
              playerLeft = true;
            });
          }
        }
      }
    });
    sub.onError((e) {
      dPrint(e.toString());
      dPrint('testing');
    });
    gameManager = ref.read(gameManagerProvider.notifier);
    final assets = ref.read(assetsProvider);
    final sharedPref = ref.read(sharedPrefProvider);

    /// check if a backgroundMusic setting exists
    final backgroundMusic = sharedPref.getBool('backgroundMusic');
    if (backgroundMusic == null || backgroundMusic == true) {
      /// initialize the audio
      FlameAudio.bgm.play(assets.audioBGGame);
    } else {
      /// play silently to load the track
      FlameAudio.bgm.play(assets.audioBGGame, volume: 0);

      /// pause after track loaded
      FlameAudio.bgm.pause();
    }
    gameManager.init(widget.room);
    sharedPref.setString('currentLeaderboardID', widget.room.currentLeaderboardID!);
    sharedPref.setString('currentRoomID', widget.room.id!);
    roomManager = ref.read(roomManagerProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
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

class DisconnectedDialog extends ConsumerWidget {
  const DisconnectedDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BLSmallTitle('You have been disconnected.'),
        BLButton(
            type: BtnType.orange,
            onPressed: () {
              nav.pop(context);
            },
            child: BLText('Proceed'))
      ],
    ));
  }
}
