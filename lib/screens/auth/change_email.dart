import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeEmail extends ConsumerStatefulWidget {
  const ChangeEmail({super.key});

  @override
  ConsumerState<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangeEmail> {
  late final String oldEmail;
  late final TextEditingController emailController;

  @override
  void initState() {
    final user = ref.read(accountProvider).value;
    oldEmail = user?.email ?? '';
    emailController = TextEditingController(text: oldEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Enter your new email'),
        const SizedBox(
          height: 10,
        ),
        BLTextBox(
          controller: emailController,
          prefixIcon: const Icon(
            Icons.mail,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
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
                  final newEmail = emailController.text.trim();
                  if (oldEmail != newEmail) {
                    AuthService.changeEmail(context, newEmail);
                  } else {
                    Utils.pop(context);
                  }
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
