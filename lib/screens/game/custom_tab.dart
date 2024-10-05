import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTab extends ConsumerWidget {
  const CustomTab({
    required this.type,
    required this.isSelected,
    required this.count,
    this.textColor,
    this.paddingX = 20,
    this.paddingY = 3,
    super.key,
  });
  final CodeBlockType type;
  final double paddingX;
  final double paddingY;
  final Color? textColor;
  final bool isSelected;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String firstLetter = type.name[0].toUpperCase();
    final String word = type.name.substring(1, type.name.length);
    return Container(
      decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.grey, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: paddingY),
      child: BLText(
        '$firstLetter$word ($count)',
        color: textColor ?? Colors.black,
        bold: isSelected,
        size: 16,
      ),
    );
  }
}
