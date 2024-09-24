import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/screens/game/block_with_child.dart';
import 'package:block_logic/screens/game/statement_block.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockRender extends ConsumerStatefulWidget {
  final GameBlockData data;
  final VoidCallback refresh;
  final bool feedback;
  const BlockRender(this.data, this.refresh, {this.feedback = false, super.key});

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
              color: widget.data.type == CodeBlockType.keywords ? Colors.black : Colors.white,
            ),
          ),
        );

      case CodeBlockState.inEditor:
        switch (widget.data.type) {
          case CodeBlockType.statement:
            // return BlockDesignWrapper(
            //   data: widget.data,
            //   child: Center(
            //     child: BLText(
            //       widget.data.name,
            //       size: 14,
            //       color: widget.data.type == CodeBlockType.keywords ? Colors.black : null,
            //     ),
            //   ),
            // );
            return StatementBox(data: widget.data);
          case CodeBlockType.loops:
          case CodeBlockType.conditionals:
            return BlockDesignWrapper(
              data: widget.data,
              child: GameBlockWithChild(
                refresh: widget.refresh,
                box: GameBox.conditions,
                // uid: widget.data.uid!,
                data: widget.data,
              ),
            );
          case CodeBlockType.objects:
          case CodeBlockType.functions:
            if (widget.data.name.contains('def')) {
              return BlockDesignWrapper(
                data: widget.data,
                child: GameBlockWithChild(
                  refresh: widget.refresh,
                  box: GameBox.parameters,
                  // uid: widget.data.uid!,
                  data: widget.data,
                ),
              );
            } else if (widget.data.name.contains('class')) {
              return BlockDesignWrapper(
                data: widget.data,
                child: GameBlockWithChild(
                  refresh: widget.refresh,
                  // uid: widget.data.uid!,
                  data: widget.data,
                ),
              );
            }
            return BlockDesignWrapper(
              data: widget.data,
              child: GameBlockWithChild(
                refresh: widget.refresh,
                box: GameBox.arguments,
                // uid: widget.data.uid!,
                data: widget.data,
              ),
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
                  color: widget.data.type == CodeBlockType.keywords ? Colors.black : Colors.white,
                ),
              ),
            );
        }
    }
  }
}
