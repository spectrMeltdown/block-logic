import 'package:block_logic/components/text.dart';
import 'package:flutter/material.dart';

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

Future<void> notifyDialog(context, {required String title, String? label}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => BLNotifyDialog(
      title: title,
      label: label,
    ),
  );
}

class BLNotifyDialog extends StatelessWidget {
  const BLNotifyDialog({super.key, required this.title, this.label});
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
