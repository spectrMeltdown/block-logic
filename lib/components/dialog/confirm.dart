import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
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
        children: [
          const BLText('Are you sure you want to leave?'),
          Row(
            children: [
              BLTextButton(
                onPressed: () => nav.pop(context, true),
                child: const BLText('Yes'),
              ),
              BLTextButton(
                onPressed: () => nav.pop(context, false),
                child: const BLText('No'),
              )
            ],
          )
        ],
      ),
    );
  }
}
