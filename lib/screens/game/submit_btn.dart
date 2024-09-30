import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:block_logic/logic/services/solution_checker.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:block_logic/screens/tutorials/practice_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSubmitButton extends ConsumerWidget {
  final void Function()? updateChallenge;
  final bool lastChallenge;
  final bool practiceMode;
  const GameSubmitButton(
    this.lastChallenge, {
    this.updateChallenge,
    required this.practiceMode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.read(gameManagerProvider.notifier);
    final score = ref.read(scoreManagerProvider.notifier);
    // final check = ref.watch(solutionCheckProvider.future);
    final check = ref.watch(solutionCheckerProvider.notifier);
    final toast = ref.read(toastProvider.notifier);
    final solutionMatch = ref.read(gameManagerProvider).solution;
    // final gameState = ref.read(gameManagerProvider);
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
          final userOutput = await check.check();
          // loop through correct answers
          for (final match in solutionMatch) {
            debugPrint('match is: $match');
            debugPrint(userOutput.toString());
            if (userOutput.toString().trim() == match.toString().trim()) {
              correct = true;
            } else {
              correct = false;
            }
          }

          if (practiceMode) {
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (context) => PracticeDialog(userOutput == null ? null : correct),
            );
          }
          // if correct, add score
          if (correct) {
            if (!practiceMode) {
              result = await score.increment(
                leaderboardID: manager.getLeaderboardID(),
                uid: FirebaseAuth.instance.currentUser!.uid,
                value: 1,
              );
            }
          }
          if (updateChallenge != null) {
            gameManager.resetTree();
            gameManager.setShouldResetAllBlocks(true);
            ref.invalidate(getRootDataProvider);
            ref.invalidate(shouldResetAllBlocksProvider);
            updateChallenge!();
          }
          if (result != null) {
            if (!context.mounted) return;
            toast.showToast(context, result, type: NotifType.error);
          }
          toggleProcessing();
        },
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              lastChallenge ? Icons.rocket_launch_outlined : Icons.arrow_forward,
              size: 16,
            ),
            SizedBox(width: 5),
            BLText(
              lastChallenge ? 'Submit' : 'Next',
              size: 16,
              color: Colors.white,
            )
          ],
        ));
  }
}
