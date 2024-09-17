import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final passController = TextEditingController();
  late final CustomNavigation nav;
  late final AuthService auth;
  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Enter your new password'),
        const SizedBox(
          height: 10,
        ),
        BLTextBox(
          controller: passController,
          keyboardType: TextInputType.visiblePassword,
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () => nav.pop(context),
                child: const BLText(
                  'Cancel',
                  color: Colors.red,
                )),
            TextButton(
                onPressed: () {
                  auth.changePass(passController.text.trim());
                },
                child: const BLText(
                  'Save',
                  color: Colors.green,
                )),
            const SizedBox(
              width: 10,
            )
          ],
        )
      ],
    ));
  }
}
