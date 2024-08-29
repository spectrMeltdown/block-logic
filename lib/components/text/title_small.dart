import 'package:block_logic/constants.dart';
import 'package:flutter/material.dart';

///@size
///default mobile is 25
class BLSmallTitle extends StatefulWidget {
  final String text;
  final double? size;
  final Color? color;
  final double bottomPadding;
  const BLSmallTitle(this.text, {super.key, this.size, this.bottomPadding = 10, this.color});

  @override
  State<BLSmallTitle> createState() => _BLSmallTitleState();
}

class _BLSmallTitleState extends State<BLSmallTitle> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: widget.color ?? Colors.white,
            fontSize: widget.size ?? getSmallTitleSize(width),
            fontWeight: FontWeight.bold,
            height: 1.05),
      ),
    );
  }

  double getSmallTitleSize(double width) {
    if (width >= desktopMin) {
      return 37.0; // Desktop size
    } else if (width >= tabletMin) {
      return 30.0; // Tablet size
    } else {
      return 25.0; // Mobile size
    }
  }
}
