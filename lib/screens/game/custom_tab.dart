import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTab extends ConsumerWidget {
  const CustomTab({
    required this.title,
    required this.isSelected,
    this.textColor,
    this.paddingX = 20,
    super.key,
  });
  final String title;
  final double paddingX;
  final Color? textColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: EdgeInsets.symmetric(horizontal: paddingX),
      child: BLText(
        title,
        color: textColor ?? Colors.black,
        bold: isSelected,
      ),
    );
  }
}
