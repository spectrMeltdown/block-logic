import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/outline.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/logic/tab_num_provider.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/game/logic/should_reset_all_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PauseDialog extends ConsumerWidget {
  const PauseDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    final gameManager = ref.read(gameManagerProvider.notifier);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLTitle('PAUSE'),
        const SizedBox(height: 20),
        BLButton(
            paddingX: 20,
            type: BtnType.orange,
            onPressed: () {
              gameManager.resetTree();
              gameManager.setShouldResetAllBlocks(true);
              gameManager.resetAllCategory();
              ref.invalidate(getRootDataProvider);
              ref.invalidate(shouldResetAllBlocksProvider);
              ref.invalidate(tabNumberProvider);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restore,
                  size: 30,
                ),
                SizedBox(
                  width: 8,
                ),
                BLText(
                  'Reset blocks',
                  color: Colors.white,
                )
              ],
            )),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BLOutlineButton(
                type: BtnType.red,
                onPressed: () async {
                  nav.pop(context, true);
                },
                child: const BLText(
                  'Exit',
                  // color: Colors.red,
                )),
            const SizedBox(width: 10),
            BLOutlineButton(
              type: BtnType.green,
              onPressed: () => nav.pop(context, false),
              child: const BLText(
                'Resume',
                // color: Colors.green,
              ),
            )
          ],
        )
      ],
    ));
  }
}
