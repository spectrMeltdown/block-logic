import 'package:flutter/material.dart';

/// For a row with spacing
class SpacedRow extends StatelessWidget {
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;
  const SpacedRow(
      {super.key,
      this.mainAxisSize = MainAxisSize.max,
      required this.spacing,
      required this.children,
      this.mainAxisAlignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      // -2 to avoid trailing space
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: spacing));
      }
    }
    return Row(mainAxisAlignment: mainAxisAlignment, mainAxisSize: mainAxisSize, children: spacedChildren);
  }
}
