import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReauthDialog extends ConsumerStatefulWidget {
  const ReauthDialog({super.key});

  @override
  ConsumerState<ReauthDialog> createState() => _ReauthDialogState();
}

class _ReauthDialogState extends ConsumerState<ReauthDialog> {
  final passwordController = TextEditingController();
  int attemptsLeft = 3;
  late Widget errorMessage;

  @override
  void initState() {
    errorMessage = const BlankWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nav = ref.read(customNavigationProvider);
    final auth = ref.read(authServiceProvider.notifier);
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      title: const BLSmallTitle('Verification'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your current password'),
          const SizedBox(height: 15),
          BLTextBox(
              controller: passwordController,
              labelText: 'Your password here',
              isObscure: true,
              keyboardType: TextInputType.visiblePassword),
          errorMessage
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => nav.pop(context, 'cancelled'),
            child: const BLText('Cancel', color: Colors.red)),
        TextButton(
            onPressed: () async {
              String? result =
                  await auth.reauth(passwordController.text.trim());
              if (!context.mounted) return;
              if (result == null) {
                nav.pop(context, 'success');
              } else if (result == 'too-many-attempts') {
                nav.pop(context, 'TOA');
              } else {
                if (attemptsLeft == 1) {
                  nav.pop(context, 'failed');
                } else {
                  attemptsLeft = attemptsLeft - 1;
                  errorMessage = Text(
                    'Wrong password. Attempts left: $attemptsLeft',
                    style: const TextStyle(color: Colors.red),
                  );
                  setState(() {});
                }
              }
            },
            child: const BLText('Submit', color: Colors.green)),
      ],
    );
  }
}
