import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
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
        const BLSmallTitle('PAUSE'),
        SizedBox(height: 20),
        BLButton(
            onPressed: () {
              gameManager.resetTree();
              ref.invalidate(getRootDataProvider);
            },
            child: BLText('Reset blocks')),
        const SizedBox(height: 10),
        BLButton(
            // TODO: update this later with room exit logic
            onPressed: () async {
              nav.pop(context); // pop the dialog
              nav.pop(context); // pop to rooms
            },
            type: BtnType.red,
            child: const BLText('Exit')),
        const SizedBox(height: 10),
        BLButton(
          onPressed: () => nav.pop(context),
          type: BtnType.green,
          child: const BLText('Back to game'),
        )
      ],
    ));
  }
}
