import 'package:block_logic/logic/services/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLRichText extends ConsumerStatefulWidget {
  final double? size;
  final Color? color;
  final TextAlign? alignment;
  final List<TextSpan> children;
  const BLRichText(this.children, {this.alignment, this.size, this.color, super.key});

  @override
  ConsumerState<BLRichText> createState() => _BLRichTextState();
}

class _BLRichTextState extends ConsumerState<BLRichText> {
  @override
  Widget build(BuildContext context) {
    // final blui = ref.read(bLUIProvider.notifier);
    final responsive = ref.read(responsiveManagerProvider.notifier);
    double width = MediaQuery.of(context).size.width;
    return RichText(
      textAlign: widget.alignment ?? TextAlign.start,
      text: TextSpan(
          style: TextStyle(
            color: widget.color ?? Colors.white,
            fontSize: widget.size ?? responsive.getTextSize(width),
          ),
          children: widget.children),
    );
  }
}
