import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenges.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/screens/game/finalizing_results.dart';
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
  late final GameManager gameManager;
  late final CustomNavigation nav;
  late final AsyncValue<List<Challenge>> challenges;
  late final DialogService dialog;
  late final RoomManager roomManager;
  int currentChallenge = 0;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final result = await dialog.show(context, const ConfirmDialog());
        if (result is bool && result) {
          await gameManager.leaveGame(false);
          if (!context.mounted) return;
          nav.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
          child: challenges.when(
              data: (challenges) {
                if (challenges.isEmpty) {
                  return const Center(
                    child: BLText('Sorry, there is a problem getting the challenges ...'),
                  );
                }
                if (currentChallenge > challenges.length) {
                  return const FinalizingResults();
                }
                return GameChallenge(
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
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    gameManager.init(widget.room);
    roomManager = ref.read(roomManagerProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    nav = ref.read(customNavigationProvider);
    challenges = ref.read(SelectedChallengesProvider(widget.room.challengeIDs!));
    super.initState();
  }

  void updateChallenge() {
    setState(() {
      currentChallenge++;
    });
  }
}
