import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminBackBtn extends ConsumerWidget {
  final bool useContext;
  const AdminBackBtn({this.useContext = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider);
    return BLAdminButton(
        type: AdminBtnType.red,
        child: const BLText('Back'),
        onPressed: () {
          if (useContext) {
            context.pop();
          } else {
            nav.pop(context);
          }
        });
  }
}
