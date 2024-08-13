import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmDialog extends ConsumerWidget {
  const ConfirmDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider);
    return BLDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BLSmallTitle('Are you sure you want to leave?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BLTextButton(
                onPressed: () => nav.pop(context, true),
                child: const BLText(
                  'Yes',
                  size: 16,
                  color: Colors.green,
                ),
              ),
              BLTextButton(
                onPressed: () => nav.pop(context, false),
                child: const BLText(
                  'No',
                  size: 16,
                  color: Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
