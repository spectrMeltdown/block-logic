import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BLTitle extends StatelessWidget {
  final String text;
  final double size;
  final double bottomPadding;
  final double topPadding;
  const BLTitle(
    this.text, {
    super.key,
    this.size = kIsWeb ? 70 : 35,
    this.bottomPadding = 20,
    this.topPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: size,
            shadows: <Shadow>[
              Shadow(blurRadius: 40, color: Colors.white.withOpacity(0.8)),
            ],
            height: 1),
      ),
    );
  }
}
