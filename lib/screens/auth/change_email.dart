import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
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
  late final AuthService auth;

  @override
  void initState() {
    final auth = ref.read(authServiceProvider.notifier);
    oldEmail = auth.getEmail();
    emailController = TextEditingController(text: oldEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nav = ref.watch(customNavigationProvider);
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
                    auth.changeEmail(newEmail);
                  } else {
                    nav.pop(context);
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
