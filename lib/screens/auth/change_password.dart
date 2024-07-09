import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final TextEditingController passController = TextEditingController();

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
                onPressed: () => Utils.pop(context),
                child: const BLText(
                  'Cancel',
                  color: Colors.red,
                )),
            TextButton(
                onPressed: () {
                  AuthService.changePass(context, passController.text.trim());
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
