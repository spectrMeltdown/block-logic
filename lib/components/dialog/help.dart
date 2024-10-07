import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLHelpDialog extends ConsumerWidget {
  final Widget child;
  const BLHelpDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.circleQuestion),
            SizedBox(width: 5),
            BLSmallTitle(
              'Help',
              bottomPadding: 5,
            )
          ],
        ),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 15),
        BLTextButton(
          onPressed: () => nav.pop(context),
          child: const BLText(
            'Back',
            color: Colors.red,
            bold: true,
            size: 18,
          ),
        )
      ],
    ));
  }
}
