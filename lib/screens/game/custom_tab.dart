import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTab extends ConsumerWidget {
  const CustomTab(this.text,
      {this.isSelected = false,
      this.textColor,
      this.isBold = false,
      super.key});
  final String text;
  final Color? textColor;
  final bool isBold;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BLText(
        text,
        color: textColor ?? Colors.black,
        bold: isSelected,
      ),
    );
  }
}
