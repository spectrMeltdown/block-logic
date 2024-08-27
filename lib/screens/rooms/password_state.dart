import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLPasswordState extends ConsumerWidget {
  final String password;
  const BLPasswordState(this.password, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blui = ref.read(bLUIProvider.notifier);
    switch (password.toLowerCase()) {
      case 'open':
        return Icon(
          FontAwesomeIcons.lockOpen,
          color: blui.getAppColor('lightgreen'),
        );
      case 'password':
        return Icon(
          FontAwesomeIcons.lock,
          color: blui.getAppColor('amber'),
        );
    }
    return const BLText('--');
  }
}
