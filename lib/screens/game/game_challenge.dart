import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/screens/game/blocks_selector.dart';
import 'package:block_logic/screens/game/challange_box.dart';
import 'package:block_logic/screens/game/editor.dart';
import 'package:block_logic/screens/game/game_appbar.dart';
import 'package:block_logic/screens/game/return_block_overlay.dart';
import 'package:block_logic/screens/game/submit_btn.dart';
import 'package:block_logic/screens/game/test_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final processingProvider = StateProvider((ref) {
  return ref.watch(gameManagerProvider.select((state) => state.processingOverlay));
});

class GameChallenge extends ConsumerWidget {
  final String roomName;
  final void Function()? updateChallenge;
  final Challenge challenge;
  final int challengeCount;
  final int currentChallenge;
  final bool practiceMode;
  const GameChallenge({
    required this.currentChallenge,
    this.updateChallenge,
    required this.roomName,
    required this.challenge,
    required this.challengeCount,
    this.practiceMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final gameManager = ref.read(gameManagerProvider.notifier);

    gameManager.updateSolution(challenge.solutionMatch!);
    // debugPrint('${widget.challengeCount}');
    // debugPrint('${widget.currentChallenge}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GameAppbar(
          roomName: roomName,
          challenge: challenge,
          currentIndex: currentChallenge,
          maxIndex: challengeCount,
          practiceMode: practiceMode,
        ),
        Flexible(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: height * 0.15,
                width: width * 0.5,
                child: ChallengeBox(
                  challenge: challenge,
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Column(
                  children: [
                    GameSubmitButton(
                      challengeCount == (currentChallenge + 1),
                      updateChallenge: updateChallenge,
                      practiceMode: practiceMode,
                      entries: challenge.blocks!.entries.toList(),
                    ),
                    const SizedBox(height: 10),
                    GameTestBtn(practiceMode),
                  ],
                ),
              )
            ]),
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
            child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                const Flexible(flex: 2, child: Editor()),
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GameBlocks(
                      // purge all empty categories
                      challenge.blocks != null ? Map.fromEntries(challenge.blocks!.entries.where((e) => e.value.isNotEmpty)) : {},
                      challenge.id!,
                    ),
                  ),
                ),
              ],
            ),
            const ReturnBlockOverlay()
          ],
        ))
      ],
    );
  }
}
