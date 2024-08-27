import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialItem extends ConsumerStatefulWidget {
  final TutorialType type;
  final VoidCallback onPressed;
  final String childText;
  final double? height;
  const TutorialItem({
    super.key,
    required this.onPressed,
    required this.childText,
    required this.type,
    this.height,
  });

  @override
  ConsumerState<TutorialItem> createState() => _TutorialItemState();
}

class _TutorialItemState extends ConsumerState<TutorialItem> {
  @override
  Widget build(BuildContext context) {
    final blui = ref.read(bLUIProvider.notifier);
    final mediaQuery = MediaQuery.of(context);
    return BLCard(
      width: mediaQuery.size.width,
      color: blui.getTutorialColor(widget.type),
      onPressed: widget.onPressed,
      innerPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.center,
            child: BLText(
              widget.childText,
              size: 23,
              color: widget.type == TutorialType.keywords ? Colors.black : Colors.white,
            ),
          ),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
