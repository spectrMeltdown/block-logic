import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewBlockBox extends ConsumerWidget {
  final double width;
  final double height;
  final BoxConstraints? constraints;
  const AddNewBlockBox({this.height = 50, this.width = 100, this.constraints, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.black.withOpacity(0.5)),
    );
  }
}
