import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChipStrip extends ConsumerStatefulWidget {
  final List<Widget> children;
  final GlobalKey btnKey;
  final void Function() onPressed;
  const ChipStrip({
    required this.children,
    required this.btnKey,
    required this.onPressed,
    super.key,
  });

  @override
  ConsumerState<ChipStrip> createState() => _ChipStripState();
}

class _ChipStripState extends ConsumerState<ChipStrip> {
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            clipBehavior: Clip.antiAlias,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SpacedRow(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: widget.children,
              ),
            ),
          ),
        )),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: BLAdminButton(
              key: widget.btnKey,
              type: AdminBtnType.green,
              onPressed: widget.onPressed,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
