import 'package:flutter/material.dart';

/// For a column with spacing
class SpacedColumn extends StatelessWidget {
  final double spacing;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  const SpacedColumn({
    super.key,
    required this.spacing,
    required this.children,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      // -2 to avoid trailing space
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    return Column(mainAxisSize: mainAxisSize, children: spacedChildren);
  }
}
