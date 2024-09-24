import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:block_logic/logic/services/solution_checker.dart';
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
    final check = ref.watch(solutionCheckProvider.future);
    final toast = ref.read(toastProvider.notifier);

    void toggleProcessing() {
      manager.toggleProcessingOverlay();
      ref.invalidate(processingProvider);
    }

    return BLButton(
        type: BtnType.green,
        onPressed: () async {
          toggleProcessing();
          final result = await check;
          if (result != null) {
            score.increment(
              leaderboardID: manager.getLeaderboardID(),
              uid: FirebaseAuth.instance.currentUser!.uid,
              value: 1,
            );
          } else {
            toast.showToast('Error checking blocks.\nCannot proceed.', type: NotifType.error);
            toggleProcessing();
            return;
          }
          if (lastChallenge) {
            manager.endGame();
          } else {
            updateChallenge();
          }
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
