import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticeDialog extends ConsumerWidget {
  final bool? correct;
  const PracticeDialog(this.correct, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    final gameManager = ref.read(gameManagerProvider.notifier);
    return BLDialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        if (correct == null) ...[
          // const Icon(
          //   Icon.Empty,
          //   color: Colors.blue,
          //   size: 50,
          // ),
          const SizedBox(
            height: 10,
          ),
          const BLSmallTitle('Empty ...'),
        ],
        if (correct != null)
          ...correct!
              ? [
                  const Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.green,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BLSmallTitle('Yey! You got the correct answer!'),
                ]
              : [
                  const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BLSmallTitle('Sorry, you got it wrong...'),
                ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BLTextButton(
                onPressed: () async {
                  gameManager.resetTree();
                  gameManager.setShouldResetAllBlocks(true);
                  ref.invalidate(getRootDataProvider);
                  ref.invalidate(shouldResetAllBlocksProvider);
                  if (!context.mounted) return;
                  nav.pop(context);
                  nav.pop(context);
                  nav.pop(context);
                },
                child: const BLText(
                  'Exit\nPractice',
                  color: Colors.deepOrange,
                  bold: true,
                  alignCenter: true,
                )),
            BLTextButton(
                onPressed: () async {
                  gameManager.resetTree();
                  gameManager.setShouldResetAllBlocks(true);
                  ref.invalidate(getRootDataProvider);
                  ref.invalidate(shouldResetAllBlocksProvider);
                  if (!context.mounted) return;
                  nav.pop(context);
                  nav.pop(context);
                },
                child: const BLText(
                  'Select\nanother',
                  color: Colors.lightBlue,
                  bold: true,
                  alignCenter: true,
                )),
            BLTextButton(
                onPressed: () async {
                  nav.pop(context);
                },
                child: const BLText(
                  'Continue\ncurrent',
                  color: Colors.green,
                  bold: true,
                  alignCenter: true,
                ))
          ],
        )
      ]),
    );
  }
}
