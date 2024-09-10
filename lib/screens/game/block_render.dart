import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/screens/game/block_with_child.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockRender extends ConsumerStatefulWidget {
  final GameBlockData data;
  const BlockRender(this.data, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockRenderState();
}

class _BlockRenderState extends ConsumerState<BlockRender> {
  @override
  Widget build(BuildContext context) {
    // debugPrint(state.toString());
    switch (widget.data.state) {
      case CodeBlockState.inSelector:
        return BlockDesignWrapper(
          data: widget.data,
          child: Center(
            child: BLText(
              widget.data.name,
              size: 14,
            ),
          ),
        );

      case CodeBlockState.inEditor:
        switch (widget.data.type) {
          case CodeBlockType.loops:
          case CodeBlockType.conditionals:
            return BlockDesignWrapper(
              data: widget.data,
              child: GameBlockWithChild(data: widget.data),
            );
          case CodeBlockType.objects:
          case CodeBlockType.functions:
            return BlockDesignWrapper(
              data: widget.data,
              child: GameBlockWithChild(data: widget.data),
            );
          case CodeBlockType.keywords:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return BlockDesignWrapper(
              data: widget.data,
              child: Center(
                child: BLText(
                  widget.data.name,
                  size: 14,
                ),
              ),
            );
        }
    }
  }
}
