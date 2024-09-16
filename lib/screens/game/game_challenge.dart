import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/return_block.dart';
import 'package:block_logic/logic/services/should_reset_block.dart';
import 'package:block_logic/screens/game/blocks_selector.dart';
import 'package:block_logic/screens/game/challange_box.dart';
import 'package:block_logic/screens/game/editor.dart';
import 'package:block_logic/screens/game/game_appbar.dart';
import 'package:block_logic/screens/game/submit_btn.dart';
import 'package:block_logic/screens/game/test_btn.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class GameChallenge extends ConsumerStatefulWidget {
  final String roomName;
  final void Function() updateChallenge;
  final Challenge challenge;
  final int challengeCount;
  final int currentChallenge;
  const GameChallenge({
    required this.currentChallenge,
    required this.updateChallenge,
    required this.roomName,
    required this.challenge,
    required this.challengeCount,
    super.key,
  });
  @override
  ConsumerState<GameChallenge> createState() => _GameChallengeState();
}

class _GameChallengeState extends ConsumerState<GameChallenge> {
  late final GameManager gameManager;
  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    if (!kDebugMode) {
      // gameManager.updateSolution(widget.challenge.solution!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final returnBlock = ref.watch(returnBlockProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GameAppbar(
          roomName: widget.roomName,
          challenge: widget.challenge,
          currentIndex: widget.currentChallenge,
          maxIndex: widget.challengeCount,
        ),
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: ChallengeBox(
                  challenge: widget.challenge,
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Column(
                  children: [
                    GameSubmitButton(widget.updateChallenge, widget.challengeCount == widget.currentChallenge),
                    const SizedBox(height: 10),
                    const GameTestBtn(),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GameBlocks(widget.challenge.blocks!),
                ),
              ],
            ),
            Visibility(
                visible: returnBlock,
                child: WidgetAnimator(
                  incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
                  outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(),
                  child: SizedBox(
                    height: 120,
                    width: double.maxFinite,
                    child: DragTargetWrapper(
                      builderChild: () {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              color: Colors.red.withOpacity(0.9),
                              border: Border.all(
                                color: Colors.black12,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                WidgetAnimator(
                                    atRestEffect: WidgetRestingEffects.bounce(
                                        effectStrength: 0.5, delay: const Duration(milliseconds: 500)),
                                    child: const Icon(
                                      Icons.download,
                                      size: 40,
                                    )),
                                const SizedBox(width: 5),
                                const BLText('Return to selector'),
                              ],
                            ),
                          ),
                        );
                      },
                      onAcceptWithDetails: (data, manager) {
                        assert(data.uid != null);
                        gameManager.deleteData(data);
                        gameManager.removeInSelectorUIDs(data.type, data.inSelectorUID!);
                        ref.invalidate(shouldResetBlockProvider);
                        ref.invalidate(getRootDataProvider);
                        switch (data.type) {
                          case CodeBlockType.functions:
                          case CodeBlockType.objects:
                          case CodeBlockType.operators:
                          case CodeBlockType.conditionals:
                          case CodeBlockType.loops:
                          case CodeBlockType.statement:
                            ref.invalidate(getSelfDataProvider);
                            ref.invalidate(getChildrenDataProvider);
                          default:
                        }
                        setState(() {});
                      },
                      onWillAcceptWithDetails: (data) {
                        if (data.state != CodeBlockState.inEditor) {
                          return false;
                        }
                        return true;
                      },
                    ),
                  ),
                ))
          ],
        ))
      ],
    );
  }
}
