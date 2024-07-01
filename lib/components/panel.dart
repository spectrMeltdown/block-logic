// panel(bgColor) panel_transparent

import 'package:flutter/material.dart';

class BLPanel extends StatelessWidget {
  const BLPanel({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(20),
        border: Border.all(color: Colors.white.withAlpha(20), width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha(40),
            blurRadius: 15,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(10),
        child: child,
      ),
    ));
  }
}
