import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';

class BLText extends StatefulWidget {
  const BLText(this.text,
      {super.key,
      this.size = 16,
      this.fontStyle = FontStyle.normal,
      this.underlined = false,
      this.bold = false,
      this.color,
      this.alignCenter = false,
      this.duration = const Duration(milliseconds: 500)});
  final String text;
  final double size;
  final bool bold;
  final FontStyle fontStyle;
  final bool underlined;
  final Color? color;
  final bool alignCenter;
  final Duration duration;

  @override
  State<BLText> createState() => _BLTextState();
}

class _BLTextState extends State<BLText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;
  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _characterCount =
        StepTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _characterCount.value),
      textAlign: widget.alignCenter == true ? TextAlign.center : null,
      style: TextStyle(
        color: widget.color ?? BLUI().getAppColor('lightBlue'),
        fontSize: widget.size,
        fontStyle: widget.fontStyle,
        fontWeight: widget.bold == true ? FontWeight.bold : null,
        decoration: widget.underlined == true ? TextDecoration.underline : null,
      ),
    );
  }
}

class BLTextSpan extends StatelessWidget {
  const BLTextSpan(this.children,
      {this.alignment, this.size = 16, this.color, super.key});
  final double size;
  final Color? color;
  final TextAlign? alignment;
  final List<TextSpan> children;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: alignment ?? TextAlign.start,
      text: TextSpan(
          style: TextStyle(
            color: color ?? BLUI().getAppColor('lightBlue'),
            fontSize: size,
          ),
          children: children),
    );
  }
}

class BLTitle extends StatelessWidget {
  const BLTitle(this.text,
      {super.key,
      this.size = 35,
      this.bottomPadding = 20,
      this.topPadding = 0});
  final String text;
  final double size;
  final double bottomPadding;
  final double topPadding;

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
            fontWeight: FontWeight.bold,
            height: 1),
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
        style: TextStyle(
            color: color ?? Colors.white,
            fontSize: size,
            fontWeight: FontWeight.bold,
            height: 1.05),
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;

  const TypewriterText(
      {required this.text,
      this.textStyle,
      this.duration = const Duration(milliseconds: 500),
      super.key});

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _characterCount =
        StepTween(begin: 0, end: widget.text.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text.substring(0, _characterCount.value),
      style: widget.textStyle,
    );
  }
}
