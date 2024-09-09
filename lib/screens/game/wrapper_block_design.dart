import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockDesignWrapper extends ConsumerStatefulWidget {
  final GameBlockData data;
  final Color? color;
  final Widget child;
  final String? text;
  final void Function()? updateSelection;
  const BlockDesignWrapper({
    required this.child,
    required this.data,
    this.color,
    this.updateSelection,
    this.text,
    super.key,
  });
  @override
  ConsumerState<BlockDesignWrapper> createState() => _BlockDesignWrapperState();
}

class _BlockDesignWrapperState extends ConsumerState<BlockDesignWrapper> {
  @override
  Widget build(BuildContext context) {
    final blui = ref.read(bLUIProvider.notifier);
    return Material(
      color: Colors.transparent,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: widget.data.state == CodeBlockState.inEditor ? Border.all(color: Colors.grey.shade700) : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: widget.data.state == CodeBlockState.inEditor
                ? blui.getBlockColor(widget.data.type).withOpacity(0.3)
                : blui.getBlockColor(widget.data.type),
          ),
          child: widget.updateSelection != null ? BLText(widget.text!) : widget.child),
    );
  }
}
