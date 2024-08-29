import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLHelpDialog extends StatefulWidget {
  final Widget child;
  const BLHelpDialog({super.key, required this.child});

  @override
  State<BLHelpDialog> createState() => _BLHelpDialogState();
}

class _BLHelpDialogState extends State<BLHelpDialog> {
  @override
  Widget build(BuildContext context) {
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
        widget.child
      ],
    ));
  }
}
