import 'package:flutter/material.dart';

class AddNewBlockBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  const AddNewBlockBox({this.height, this.width, this.constraints, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.black.withValues(alpha: 0.3),
      ),
      child: Icon(
        Icons.add_outlined,
        color: Colors.white.withValues(alpha: 0.3),
      ),
    );
  }
}
