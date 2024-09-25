import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSubmitButton extends ConsumerWidget {
  final void Function() updateChallenge;
  final bool lastChallenge;
  const GameSubmitButton(this.updateChallenge, this.lastChallenge, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(gameManagerProvider.notifier);
    final score = ref.read(scoreManagerProvider.notifier);
    // final check = ref.watch(solutionCheckProvider.future);
    final toast = ref.read(toastProvider.notifier);
    final solutionMatch = ref.read(gameManagerProvider).solution;
    final gameState = ref.read(gameManagerProvider);
    final gameManager = ref.read(gameManagerProvider.notifier);

    void toggleProcessing() {
      manager.toggleProcessingOverlay();
      ref.invalidate(processingProvider);
    }

    return BLButton(
        type: BtnType.green,
        onPressed: () async {
          toggleProcessing();
          bool correct = false;
          String? result;
          const userOutput = '5'; //await check;
          // loop through correct answers
          for (final match in solutionMatch) {
            if (userOutput.toString() == match.toString()) {
              correct = true;
            } else {
              correct = false;
            }
          }

          // if correct, add score
          if (correct) {
            debugPrint('Score incremented');

            result = await score.increment(
              leaderboardID: manager.getLeaderboardID(),
              uid: FirebaseAuth.instance.currentUser!.uid,
              value: 1,
            );
          }
          gameManager.resetTree();
          gameManager.setShouldResetAllBlocks(true);
          ref.invalidate(getRootDataProvider);
          ref.invalidate(shouldResetAllBlocksProvider);
          updateChallenge();
          if (result != null) {
            toast.showToast(result, type: NotifType.error);
          }
          toggleProcessing();
        },
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_outlined,
              size: 16,
            ),
            SizedBox(width: 5),
            BLText(
              'Submit',
              size: 16,
              color: Colors.white,
            )
          ],
        ));
  }
}
