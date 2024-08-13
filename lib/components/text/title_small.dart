import 'package:flutter/material.dart';

class BLSmallTitle extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  const BLSmallTitle(this.text, {super.key, this.size = 25, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: color ?? Colors.white,
            fontSize: size,
            fontWeight: FontWeight.bold,
            height: 1.05),
      ),
    );
  }
}
