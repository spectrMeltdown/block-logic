import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmDialog extends ConsumerWidget {
  final String title;
  final String? message;
  const ConfirmDialog({this.title = 'Are you sure you want to leave?', this.message, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLSmallTitle(title),
            if (message != null) BLText(message!),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: kIsWeb ? MainAxisAlignment.center : MainAxisAlignment.end,
              children: [
                BLTextButton(
                  onPressed: () => nav.pop(context, true),
                  child: const BLText(
                    'Yes',
                    size: 16,
                    bold: true,
                    color: Colors.green,
                  ),
                ),
                BLTextButton(
                  onPressed: () => nav.pop(context, false),
                  child: const BLText(
                    'No',
                    size: 16,
                    bold: true,
                    color: Colors.red,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
