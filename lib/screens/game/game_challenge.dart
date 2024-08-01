import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/screens/game/blocks_selector.dart';
import 'package:block_logic/screens/game/challange_box.dart';
import 'package:block_logic/screens/game/editor.dart';
import 'package:block_logic/screens/game/game_appbar.dart';
import 'package:block_logic/screens/game/run_btn.dart';
import 'package:block_logic/screens/game/submit_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameChallenge extends ConsumerWidget {
  const GameChallenge(
      {required this.roomName,
      required this.challenge,
      required this.challengeCount,
      super.key});
  final String roomName;
  final Challenge challenge;
  final int challengeCount;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 25),
        // TODO: change to intercept challenges & room from firestore
        GameAppbar(
            roomName: roomName,
            challengeName: challenge.name ?? '',
            challengesCount: challengeCount),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: BLMediaQuery().screenH(context) / 8.3,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ChallengeBox(
                challenge: challenge,
              ),
              const SizedBox(width: 10),
              Container(
                constraints: BoxConstraints(
                    maxWidth: BLMediaQuery().screenW(context) / 2.9),
                child: const Column(
                  children: [
                    GameSubmitButton(),
                    SizedBox(height: 10),
                    GameRunButton(),
                  ],
                ),
              )
            ]),
          ),
        ),
        const SizedBox(height: 10),
        const Editor(),
        // TODO: get blocks from challenge, save to gameManager, load into gameManager
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GameBlocks(AllBlocks.getAllBlocks())),
      ],
    );
  }
}
