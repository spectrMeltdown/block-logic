import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:flutter/material.dart';

Future<void> blShowNotifyDialog(context, {required String title, String? label}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => NotifyDialog(
      title: title,
      label: label,
    ),
  );
}

Future<String?> blShowReauthDialog(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => const ReauthDialog(),
  );
}

class BLDialog extends StatelessWidget {
  const BLDialog({super.key, required this.child, this.padding, this.insetPadding});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? insetPadding;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Padding(padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 30), child: child),
    );
  }
}

class NotifyDialog extends StatelessWidget {
  const NotifyDialog({super.key, required this.title, this.label});
  final String title;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: (label == null ? null : BLText(label ?? '')),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'))
      ],
    );
  }
}

class ReauthDialog extends StatefulWidget {
  const ReauthDialog({super.key});

  @override
  State<ReauthDialog> createState() => _ReauthDialogState();
}

class _ReauthDialogState extends State<ReauthDialog> {
  final passwordController = TextEditingController();
  int attemptsLeft = 3;
  Widget errorMessage = blankWidget;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
        TextButton(onPressed: () => Utils.pop(context, 'cancelled'), child: const BLText('Cancel', color: Colors.red)),
        TextButton(
            onPressed: () async {
              String result = await AuthService.reauth(context, passwordController.text.trim());
              if (!context.mounted) return;
              if (result == 'success') {
                Utils.pop(context, 'success');
              } else if (result == 'too-many-attempts') {
                Utils.pop(context, 'TOA');
              } else {
                if (attemptsLeft == 1) {
                  Utils.pop(context, 'failed');
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
