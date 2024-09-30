import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumPromptDialog extends ConsumerWidget {
  const PremiumPromptDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    // TODO: await reportsManager.add(ReportType.freeUsers, 1);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('This is a demo version'),
        const SizedBox(
          height: 20,
        ),
        BLTextButton(
          onPressed: () => nav.pop(context),
          child: const BLText(
            'Back',
            color: Colors.red,
            bold: true,
            alignCenter: true,
            size: 18,
          ),
        ),
      ],
    ));
  }
}
