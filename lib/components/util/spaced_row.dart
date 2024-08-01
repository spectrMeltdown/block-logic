import 'package:flutter/material.dart';

/// For a row with spacing
class SpacedRow extends StatelessWidget {
  const SpacedRow(
      {super.key,
      this.mainAxisSize = MainAxisSize.max,
      required this.spacing,
      required this.children});
  final double spacing;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;

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
    return Row(mainAxisSize: mainAxisSize, children: spacedChildren);
  }
}
