import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> blShowNotifyDialog(context,
    {required String title, String? label}) async {
  try {
    return showDialog(
      context: context,
      builder: (BuildContext context) => NotifyDialog(
        title: title,
        label: label,
      ),
    );
  } catch (e) {
    debugPrint('blShowNotifyDialog');
  }
}

class BLDialog extends StatelessWidget {
  const BLDialog(
      {super.key, required this.child, this.padding, this.insetPadding});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? insetPadding;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: BLUI().getAppColor('grey'), width: 3),
            color: Colors.black12,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    const BoxShadow(color: Colors.black12),
                    BoxShadow(
                        color: Colors.blueGrey.shade800,
                        spreadRadius: -5,
                        blurRadius: 20)
                  ]),
              child: Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: child,
              ))),
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
    final nav = ref.read(navProvider);
    final auth = ref.read(authServiceStateProvider.notifier);
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
        TextButton(
            onPressed: () => nav.pop(context, 'cancelled'),
            child: const BLText('Cancel', color: Colors.red)),
        TextButton(
            onPressed: () async {
              String result = await auth.reauth(passwordController.text.trim());
              if (!context.mounted) return;
              if (result == 'success') {
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
