import 'package:flutter/material.dart';

class BLScrollable extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? controller;
  const BLScrollable({required this.child, this.scrollDirection = Axis.vertical, this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final defaultController = ScrollController();
    return Scrollbar(
        controller: controller ?? defaultController,
        child: SingleChildScrollView(
          controller: controller ?? defaultController,
          scrollDirection: scrollDirection,
        ));
  }
}
