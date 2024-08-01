import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wraps topLevel box in a SingleChildScrollView, or wraps children of a block in a column
class BlockWrapper extends ConsumerStatefulWidget {
  const BlockWrapper({required this.widgetList, super.key});
  final List<Widget> widgetList;

  @override
  ConsumerState<BlockWrapper> createState() => _BlockWrapperState();
}

class _BlockWrapperState extends ConsumerState<BlockWrapper> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.widgetList.length, (i) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: widget.widgetList[i],
              )
            ],
          );
        }),
      ),
    );
  }
}
