import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLHelpDialog extends ConsumerStatefulWidget {
  final Widget child;
  const BLHelpDialog({super.key, required this.child});

  @override
  ConsumerState<BLHelpDialog> createState() => _BLHelpDialogState();
}

class _BLHelpDialogState extends ConsumerState<BLHelpDialog> {
  late final CustomNavigation nav;

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

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
        widget.child,
        const SizedBox(height: 10),
        BLButton(
          type: BtnType.red,
          onPressed: () => nav.pop(context),
          child: const BLText('Back'),
        )
      ],
    ));
  }
}
