import 'package:block_logic/components/custom_widgets.dart';
import 'package:flutter/material.dart';

enum LoadingType { full, normal }

class BLLoading extends StatelessWidget {
  const BLLoading({super.key, this.type = LoadingType.full});
  final LoadingType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.full:
        return const Center(child: CircularProgressIndicator());
      case LoadingType.normal:
        return const CircularProgressIndicator();
      default:
        return blankWidget;
    }
  }
}
