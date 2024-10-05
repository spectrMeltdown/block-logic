import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewBlockBox extends ConsumerWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  const AddNewBlockBox({this.height, this.width, this.constraints, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.black.withOpacity(0.3)),
      child: Icon(
        Icons.add_outlined,
        color: Colors.white.withOpacity(0.3),
      ),
    );
  }
}
