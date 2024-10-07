import 'package:block_logic/logic/services/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLRichText extends ConsumerWidget {
  final double? size;
  final Color? color;
  final TextAlign? alignment;
  final List<TextSpan> children;
  const BLRichText(this.children, {this.alignment, this.size, this.color, super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final blui = ref.read(bLUIProvider.notifier);
    final responsive = ref.read(responsiveManagerProvider.notifier);
    double width = MediaQuery.of(context).size.width;
    return RichText(
      textAlign: alignment ?? TextAlign.start,
      text: TextSpan(
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: size ?? responsive.getTextSize(width),
          ),
          children: children),
    );
  }
}
