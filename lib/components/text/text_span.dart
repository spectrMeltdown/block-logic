import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLTextSpan extends ConsumerWidget {
  final double size;
  final Color? color;
  final TextAlign? alignment;
  final List<TextSpan> children;
  const BLTextSpan(this.children,
      {this.alignment, this.size = 16, this.color, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blui = ref.read(bLUIProvider);
    return RichText(
      textAlign: alignment ?? TextAlign.start,
      text: TextSpan(
          style: TextStyle(
            color: color ?? blui.getAppColor('lightBlue'),
            fontSize: size,
          ),
          children: children),
    );
  }
}
