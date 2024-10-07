import 'package:block_logic/logic/services/game/game_manager.dart';
import 'package:block_logic/logic/services/game/return_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game/game_provider.dart';
import 'package:block_logic/logic/services/game/should_reset_block.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ReturnBlockOverlay extends ConsumerWidget {
  const ReturnBlockOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.read(gameManagerProvider.notifier);
    final returnBlock = ref.watch(returnBlockProvider);
    return Visibility(
        visible: returnBlock,
        child: WidgetAnimator(
          incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
          outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            height: 120,
            width: double.maxFinite,
            child: DragTargetWrapper(
              builderChild: () {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          atRestEffect: WidgetRestingEffects.bounce(effectStrength: 0.5, delay: const Duration(milliseconds: 500)),
                          child: const Icon(
                            Icons.download,
                            size: 40,
                          )),
                      const SizedBox(width: 5),
                      const BLText('Return to selector'),
                    ],
                  ),
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                assert(dataToAccept.uid != null);
                gameManager.deleteData(dataToAccept.copyWith()); //mark data to delete
                gameManager.removeInSelectorUIDs(dataToAccept.copyWith());

                // actual removal from tree
                gameManager.removeSelectedInSelectorUIDs();
                gameManager.deleteSelectedData();
                Future.delayed(Duration.zero, () {
                  ref.invalidate(getRootDataProvider);
                });
                Future.delayed(Duration.zero, () {
                  ref.invalidate(getSelfDataProvider);
                });
                Future.delayed(Duration.zero, () {
                  ref.invalidate(getChildrenDataProvider);
                });
                Future.delayed(Duration.zero, () {
                  ref.invalidate(shouldResetBlockProvider);
                });

                // ref.invalidate(getRootDataProvider);
                // ref.invalidate(getSelfDataProvider);
                // ref.invalidate(getChildrenDataProvider);
                ref.invalidate(shouldResetBlockProvider);
              },
              onWillAcceptWithDetails: (dataToAccept) {
                if (dataToAccept.state != CodeBlockState.inEditor) {
                  return false;
                }
                return true;
              },
            ),
          ),
        ));
  }
}
