import 'package:flutter/material.dart';

class BLText extends StatelessWidget {
  const BLText(this.text,
      {super.key,
      this.size = 16,
      this.fontStyle = FontStyle.normal,
      this.underlined = false,
      this.color,
      this.alignCenter = false});
  final String text;
  final double size;
  final FontStyle fontStyle;
  final bool underlined;
  final Color? color;
  final bool alignCenter;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignCenter == true ? TextAlign.center : null,
      style: TextStyle(
          color: color ?? Colors.lightBlue[100],
          fontSize: size,
          fontStyle: fontStyle,
          decoration: underlined == true ? TextDecoration.underline : null),
    );
  }
}

class BLTitle extends StatelessWidget {
  const BLTitle(this.text, {super.key, this.size = 35});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: size, fontWeight: FontWeight.bold, height: 1.05),
      ),
    );
  }
}

class BLSmallTitle extends StatelessWidget {
  const BLSmallTitle(this.text, {super.key, this.size = 25, this.color});
  final String text;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color ?? Colors.white, fontSize: size, fontWeight: FontWeight.bold, height: 1.05),
      ),
    );
  }
}
