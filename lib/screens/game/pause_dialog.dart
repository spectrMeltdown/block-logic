import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PauseDialog extends ConsumerWidget {
  const PauseDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(customNavigationProvider);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('PAUSE'),
        BLButton(
            // TODO: update this later with room exit logic
            onPressed: () async {
              nav.pop(context);
              nav.pop(context);
            },
            type: BtnType.red,
            child: const BLText('Exit')),
        const SizedBox(height: 10),
        BLButton(
            onPressed: () => nav.pop(context),
            type: BtnType.green,
            child: const BLText('Back to game'))
      ],
    ));
  }
}
