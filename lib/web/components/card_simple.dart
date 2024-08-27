import 'package:block_logic/logic/services/color.dart';
import 'package:flutter/material.dart';

class BLCardSimple extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? brightness;
  const BLCardSimple({required this.child, super.key, this.color, this.brightness});

  @override
  Widget build(BuildContext context) {
    final defaultColor = Colors.blueGrey.shade800;
    return Card(
      color: color ?? (brightness != null ? defaultColor.brighten(brightness!) : defaultColor),
      child: child,
    );
  }
}
