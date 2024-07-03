import 'package:flutter/material.dart';

/// For placeholder widgets with zero size
const Widget blankWidget = SizedBox.shrink();

/// For a column with spacing
class SpacedColumn extends StatelessWidget {
  const SpacedColumn({super.key, required this.spacing, required this.children});
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      // -2 to avoid trailing space
      if (i < children.length - 2) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    return Column(children: spacedChildren);
  }
}

/// For a row with spacing
class SpacedRow extends StatelessWidget {
  const SpacedRow({super.key, required this.spacing, required this.children});
  final double spacing;
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
    return Row(children: spacedChildren);
  }
}
