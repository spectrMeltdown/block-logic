import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';

class BLText extends StatefulWidget {
  final bool softWrap;
  final int? maxLines;
  final String text;
  final bool animated;
  final double? size;
  final bool bold;
  final FontStyle fontStyle;
  final bool underlined;
  final Color? color;
  final bool alignCenter;
  final Duration duration;
  const BLText(this.text,
      {super.key,
      this.size = 14,
      this.fontStyle = FontStyle.normal,
      this.underlined = false,
      this.bold = false,
      this.color,
      this.alignCenter = false,
      this.animated = false,
      this.softWrap = false,
      this.maxLines,
      this.duration = const Duration(milliseconds: 500)});

  @override
  State<BLText> createState() => _BLTextState();
}

class _BLTextState extends State<BLText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.animated
          ? widget.text.substring(0, _characterCount.value)
          : widget.text,
      textAlign: widget.alignCenter == true ? TextAlign.center : null,
      softWrap: widget.softWrap,
      maxLines: widget.maxLines,
      style: TextStyle(
        color: widget.color ?? BLUI().getAppColor('lightBlue'),
        fontSize: widget.size,
        fontStyle: widget.fontStyle,
        fontWeight: widget.bold == true ? FontWeight.bold : null,
        decoration: widget.underlined == true ? TextDecoration.underline : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
}
