import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Enter your email:'),
        const SizedBox(height: 10),
        BLTextBox(
          controller: emailController,
          prefixIcon: const Icon(
            Icons.mail,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const BLText(
                  'Cancel',
                  color: Colors.red,
                )),
            TextButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  auth.forgotPass(email);
                },
                child: const BLText(
                  'Submit',
                  color: Colors.green,
                )),
            const SizedBox(width: 10)
          ],
        )
      ],
    ));
  }
}
