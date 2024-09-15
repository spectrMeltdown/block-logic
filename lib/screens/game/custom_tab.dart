import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTab extends ConsumerStatefulWidget {
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
  ConsumerState<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends ConsumerState<CustomTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final String firstLetter;
  late final String word;
  @override
  void initState() {
    firstLetter = widget.type.name[0].toUpperCase();
    word = widget.type.name.substring(1, widget.type.name.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
          color: widget.isSelected ? Colors.white : Colors.grey,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: EdgeInsets.symmetric(horizontal: widget.paddingX, vertical: widget.paddingY),
      child: BLText(
        '$firstLetter$word (${widget.count})',
        color: widget.textColor ?? Colors.black,
        bold: widget.isSelected,
        size: 16,
      ),
    );
  }
}
