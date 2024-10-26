import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/tab_num_provider.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:block_logic/logic/services/solution_checker.dart';
import 'package:block_logic/logic/game/logic/time_box.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:block_logic/screens/tutorials/practice_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameSubmitButton extends ConsumerStatefulWidget {
  final void Function()? updateChallenge;
  final bool lastChallenge;
  final bool practiceMode;
  final List<MapEntry<CodeBlockType, List<GameBlockData>>> entries;
  const GameSubmitButton(
    this.lastChallenge, {
    this.updateChallenge,
    required this.entries,
    required this.practiceMode,
    super.key,
  });

  @override
  ConsumerState<GameSubmitButton> createState() => _GameSubmitButtonState();
}

class _GameSubmitButtonState extends ConsumerState<GameSubmitButton> {
  late final GameManager manager;
  late final ScoreManager score;
  late final Toast toast;
  late final List<dynamic> solutionMatch;
  late final GameState gameState;

  @override
  void initState() {
    super.initState();
    manager = ref.read(gameManagerProvider.notifier);
    score = ref.read(scoreManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    solutionMatch = ref.read(gameManagerProvider).solution;
    gameState = ref.read(gameManagerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final checker = ref.watch(solutionCheckerProvider.notifier);

    void toggleProcessing() {
      manager.toggleProcessingOverlay();
      ref.invalidate(processingProvider);
    }

    return BLButton(
        type: BtnType.green,
        onPressed: () async {
          toggleProcessing();
          // pause if not practice mode
          if (!widget.practiceMode) {
            manager.pauseTimer();
            ref.invalidate(runTimerProvider);
          }
          // re evaluate total blocks (changes when challenge is changed)
          int challengeBlockCount = 0;
          for (final entry in widget.entries) {
            for (final data in entry.value) {
              if (data.optional == null || data.optional == true) {
                challengeBlockCount++;
              }
            }
          }
          // if the user didn't use all required blocks
          late final bool incompleteBlocks;

          // blocks the player used
          int usedBlockCount = 0;

          // count all blocks except statements
          for (final data in gameState.dataTree.values) {
            if (data.statementUIDs == null) {
              usedBlockCount++;
            }
          }

          // dPrint('Used blocks: $usedBlockCount');
          // dPrint('total blocks: $challengeBlockCount');

          // if used blocks are not equal to or higher than total, then it is incomplete
          incompleteBlocks = !(usedBlockCount >= challengeBlockCount);

          if (!widget.practiceMode) {
            // if (!dontShowAgain) {
            //   bool result = await showDialog(context: context, builder: (context) => const NoSolution());
            //   if (!result) {
            //     toggleProcessing();
            //     return;
            //   }
            // }
            if (gameState.dataTree.isEmpty) {
              bool result = await showDialog(context: context, builder: (context) => const NoSolution());
              if (!result) {
                toggleProcessing();
                if (!widget.practiceMode) {
                  manager.resumeTimer();
                  ref.invalidate(runTimerProvider);
                }
                return;
              }
            } else if (incompleteBlocks && !gameState.autoProceed) {
              if (!context.mounted) return;
              List<bool> result = await showDialog(context: context, builder: (context) => const IncompleteBlocks());
              // cancel action
              if (!result.first) {
                toggleProcessing();
                if (!widget.practiceMode) {
                  manager.resumeTimer();
                  ref.invalidate(runTimerProvider);
                }
                return;
              }
              // if dont show again
              if (result[1]) {
                gameState.dontShowAgain = true;
                gameState.autoProceed = true;
              }
            }
          }
          bool correct = false;

          String? result;
          final userOutput = await checker.check();
          // loop through correct answers
          for (final match in solutionMatch) {
            // dPrint('match is: $match');
            // dPrint(userOutput.toString());
            if (match.toString().trim().contains(userOutput.toString().trim())) {
              correct = true;
            } else {
              correct = false;
            }
          }

          if (widget.practiceMode) {
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (context) => PracticeDialog(userOutput == null ? null : correct),
            );
          }
          // if correct, complete blocks, and not practice mode
          if (correct && !incompleteBlocks && !widget.practiceMode) {
            // don't write score in debug mode
            result = await score.increment(
              leaderboardID: manager.getLeaderboardID(),
              uid: FirebaseAuth.instance.currentUser!.uid,
              value: 1,
            );
          }
          // updateChallenge is null in practice mode!
          if (widget.updateChallenge != null) {
            // move to next challenge
            gameState.dataTree = {}; // remove all used blocks
            gameState.countsPerTab.clear(); // different from resetAllTabCount!
            gameState.inSelectorUIDs.clear();
            gameState.solution = [];
            ref.invalidate(tabNumberProvider);
            ref.invalidate(getRootDataProvider);
            Future.delayed(Duration.zero, () {
              widget.updateChallenge!();
            });
            // refresh providers
          }

          // if there was an error updating score, notify the player
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          if (!context.mounted) return;
          if (result != null) {
            toast.showToast(context, result, type: NotifType.error);
          } else if (correct && result == null && !widget.practiceMode) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 3),
                padding: EdgeInsets.symmetric(vertical: 5),
                backgroundColor: Colors.green.shade800,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(FontAwesomeIcons.circleCheck, size: 16), SizedBox(width: 10), BLText('Correct!')],
                )));
            // toast.showToast(context, 'Correct!', type: NotifType.success);
          } else if (!widget.practiceMode) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 3),
                padding: EdgeInsets.symmetric(vertical: 5),
                backgroundColor: Colors.red.shade800,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(FontAwesomeIcons.circleXmark, size: 16), SizedBox(width: 10), BLText('Wrong...')],
                )));
          }

          // remove overlay
          toggleProcessing();

          // resume timer
          if (!widget.practiceMode) {
            manager.resumeTimer();
            ref.invalidate(runTimerProvider);
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.lastChallenge ? Icons.rocket_launch_outlined : Icons.arrow_forward,
              size: 16,
            ),
            const SizedBox(width: 5),
            BLText(
              widget.lastChallenge ? 'Submit' : 'Next',
              size: 16,
              color: Colors.white,
            )
          ],
        ));
  }
}

class IncompleteBlocks extends ConsumerStatefulWidget {
  const IncompleteBlocks({super.key});

  @override
  ConsumerState<IncompleteBlocks> createState() => _IncompleteBlocksState();
}

class _IncompleteBlocksState extends ConsumerState<IncompleteBlocks> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BLSmallTitle('WARNING:'),
          const SizedBox(
            height: 5,
          ),
          const BLText(
            'You didn\'t use all the blocks.\nYou will earn no points.',
            alignCenter: true,
            softWrap: true,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                  value: checked,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        checked = value;
                      });
                    }
                  }),
              const BLText(
                'Don\'t ask next time',
                softWrap: true,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              BLTextButton(
                onPressed: () => nav.pop(context, [true, checked]),
                child: const BLText(
                  'Proceed',
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              BLTextButton(
                onPressed: () => nav.pop(context, [false, checked]),
                child: const BLText(
                  'Cancel',
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// class NextChallengeReminder extends ConsumerStatefulWidget {
//   const NextChallengeReminder({super.key});

//   @override
//   ConsumerState<NextChallengeReminder> createState() => _NextChallengeReminderState();
// }

// class _NextChallengeReminderState extends ConsumerState<NextChallengeReminder> {
//   bool checked = false;
// @override
//   Widget build(BuildContext context) {
//     final nav = ref.read(customNavigationProvider.notifier);
//     return BLDialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const BLText('Score will be finalized.\nYou cannot edit your solution later.'),
//           const SizedBox(
//             height: 15,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,children: [
//             Checkbox(value: checked, onChanged: (value){
//             if (value != null) {
//               setState(() {
//                 checked = value;
//               });
//             }
//           }),
//             const SizedBox(
//             width: 5,
//           ),
//            const BLText(
//                   'Don\'t show again',
//                   color: Colors.green,
//                 ),
//           ],),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               BLTextButton(
//                 onPressed: () => nav.pop(context, true),
//                 child: const BLText(
//                   'Yes',
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               BLTextButton(
//                 onPressed: () => nav.pop(context, true),
//                 child: const BLText(
//                   'No',
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

class NoSolution extends ConsumerWidget {
  const NoSolution({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BLText('Empty! Proceed?'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              BLTextButton(
                onPressed: () => nav.pop(context, true),
                child: const BLText(
                  'Yes',
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              BLTextButton(
                onPressed: () => nav.pop(context, false),
                child: const BLText(
                  'No',
                  color: Colors.red,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
