import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenges.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRoom extends ConsumerStatefulWidget {
  final Room room;
  const GameRoom(this.room, {super.key});

  @override
  ConsumerState<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends ConsumerState<GameRoom> {
  late Challenge currentChallenge;
  late GameManager gameManager;

  @override
  Widget build(BuildContext context) {
    //TODO: have a gamehost controller that will react to host actions, like when game start
    //TODO: when game starts, display challenge and limitation overlay
    //final gameHost = ref.watch(gameHostProvider);
    final gameState = ref.watch(gameManagerProvider);
    //final room = ref.read(GameRoomProvider(widget.roomID));
    final challenges =
        ref.read(SelectedChallengesProvider(widget.room.challengeIDs!));
    gameManager.assignRoom(widget.room);
    final dialog = ref.read(dialogServiceStateProvider);
    setState(() {
      currentChallenge = gameState.currentChallenge!;
    });
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final result = await dialog.show(context, const ConfirmDialog());
        if (result is bool && result) {
          await gameManager.leaveGame();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
          child: challenges.when(
              data: (challenges) {
                gameManager.assignChallenges(challenges);
                gameManager.createLeaderboard();
                return GameChallenge(
                  roomName: widget.room.name ?? '',
                  challenge: currentChallenge,
                  challengeCount: gameManager.getChallengesLength(),
                );
              },
              error: genericError,
              loading: genericLoading),
        ),
      ),
    );

    // room.when(
    //   data: (room) {
    //     if (room == null) return blankLoading();
    //     final challenges = ref.read(ChallengesRoomProvider(room.challengeIDs));
    //     challenges.when(
    //         data: (challenges) {
    //           if (challenges.isEmpty) return blankLoading();
    //           // TODO: insert here when ready to do testing with network
    //         },
    //         error: genericError,
    //         loading: genericLoading);
    //   },
    //   error: genericError,
    //   loading: genericLoading,
    // );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
