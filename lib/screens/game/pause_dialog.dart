import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/outline.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PauseDialog extends ConsumerStatefulWidget {
  // final void Function() refreshState;
  const PauseDialog(
      // this.refreshState,
      {
    super.key,
  });

  @override
  ConsumerState<PauseDialog> createState() => _PauseDialogState();
}

class _PauseDialogState extends ConsumerState<PauseDialog> {
  late final CustomNavigation nav;
  late final GameManager gameManager;
  @override
  void initState() {
    nav = ref.read(customNavigationProvider);
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              ref.invalidate(getRootDataProvider);
              ref.invalidate(shouldResetAllBlocksProvider);
              // ref.invalidate(getSelfDataProvider);
              // ref.invalidate(getChildrenDataProvider);
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
