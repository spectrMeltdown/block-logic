import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';

Future<void> blShowNotifyDialog(context, {required String title, String? label}) async {
  try {
    return showDialog(
      context: context,
      builder: (BuildContext context) => NotifyDialog(
        title: title,
        label: label,
      ),
    );
  } catch (e) {
    dPrint('blShowNotifyDialog');
  }
}

class BLDialog extends StatelessWidget {
  const BLDialog({super.key, required this.child, this.padding, this.color, this.insetPadding});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? insetPadding;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: BLUI().getAppColor('grey'), width: 3),
            color: Colors.black,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)), boxShadow: [const BoxShadow(color: Colors.black12), BoxShadow(color: color ?? Colors.blueGrey.shade800, spreadRadius: -5, blurRadius: 20)]),
              child: Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
