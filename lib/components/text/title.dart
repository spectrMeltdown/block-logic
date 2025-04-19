import 'package:block_logic/constants.dart';
import 'package:flutter/material.dart';

class BLTitle extends StatefulWidget {
  final String text;
  final double? size;
  final double bottomPadding;
  final double topPadding;
  final bool allCaps;
  const BLTitle(
    this.text, {
    super.key,
    this.allCaps = true,
    this.size,
    this.bottomPadding = 20,
    this.topPadding = 0,
  });

  @override
  State<BLTitle> createState() => _BLTitleState();
}

class _BLTitleState extends State<BLTitle> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Text(
        widget.allCaps ? widget.text.toUpperCase() : widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: widget.size ?? getTitleSize(width),
            shadows: <Shadow>[
              Shadow(blurRadius: 40, color: Colors.white.withValues(alpha: 0.8)),
            ],
            height: 1),
      ),
    );
  }

  double getTitleSize(double width) {
    if (width >= desktopMin) {
      return 49.0; // Desktop size
    } else if (width >= tabletMin) {
      return 42.0; // Tablet size
    } else {
      return 35.0; // Mobile size
    }
  }
}
