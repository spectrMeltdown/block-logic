import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/score_manager.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:block_logic/logic/services/solution_checker.dart';
import 'package:block_logic/logic/services/time_box.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:block_logic/screens/tutorials/practice_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  bool dontShowAgain = false;
  bool autoProceed = false;
  late int challengeBlockCount;

  @override
  void initState() {
    manager = ref.read(gameManagerProvider.notifier);
    score = ref.read(scoreManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    solutionMatch = ref.read(gameManagerProvider).solution;
    gameState = ref.read(gameManagerProvider);
    for (final entry in widget.entries) {
      for (final data in entry.value) {
        if (data.optional != null && !data.optional!) {
          challengeBlockCount++;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final check = ref.watch(solutionCheckerProvider.notifier);

    void toggleProcessing() {
      manager.toggleProcessingOverlay();
      ref.invalidate(processingProvider);
    }

    return BLButton(
        type: BtnType.green,
        onPressed: () async {
          toggleProcessing();
          if (!widget.practiceMode) {
            manager.pauseTimer();
            ref.invalidate(runTimerProvider);
          }
          late final bool incompleteBlocks;
          int usedBlockCount = 0;
          for (final data in gameState.dataTree.values) {
            if (data.statementUIDs != null) {
              usedBlockCount++;
            }
          }
          incompleteBlocks = usedBlockCount >= challengeBlockCount;
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
            } else if (incompleteBlocks && !autoProceed) {
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
                setState(() {
                  dontShowAgain = true;
                  autoProceed = true;
                });
              }
            }
          }
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

          if (widget.practiceMode) {
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (context) => PracticeDialog(userOutput == null ? null : correct),
            );
          }
          // if correct, add score
          if (correct && !incompleteBlocks && !widget.practiceMode) {
            result = await score.increment(
              leaderboardID: manager.getLeaderboardID(),
              uid: FirebaseAuth.instance.currentUser!.uid,
              value: 1,
            );
          }
          if (widget.updateChallenge != null) {
            manager.resetTree();
            manager.setShouldResetAllBlocks(true);
            ref.invalidate(getRootDataProvider);
            ref.invalidate(shouldResetAllBlocksProvider);
            if (!widget.practiceMode) {
              manager.resumeTimer();
              ref.invalidate(runTimerProvider);
            }
            widget.updateChallenge!();
          }
          if (result != null) {
            if (!context.mounted) return;
            toast.showToast(context, result, type: NotifType.error);
          }

          toggleProcessing();
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
          BLSmallTitle('WARNING:'),
          SizedBox(
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
