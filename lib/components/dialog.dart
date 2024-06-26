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
