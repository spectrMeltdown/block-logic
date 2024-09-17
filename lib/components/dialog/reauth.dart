import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
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
  bool processing = false;
  late final CustomNavigation nav;
  late final AuthService auth;

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            nav.pop(context, 'cancelled');
          },
          child: BLText(
            'Cancel',
            color: processing ? Colors.grey : Colors.red,
          ),
        ),
        TextButton(
          onPressed: () async {
            if (processing) return;
            setState(() {
              processing = true;
            });
            String? result = await auth.reauth(passwordController.text.trim());
            if (!context.mounted) return;
            if (result == null) {
              nav.pop(context, null);
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
            setState(() {
              processing = false;
            });
          },
          child: BLText(
            'Submit',
            color: processing ? Colors.grey : Colors.green,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    errorMessage = const BlankWidget();
    super.initState();
  }
}
