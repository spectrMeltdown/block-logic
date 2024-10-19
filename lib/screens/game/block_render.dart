import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/screens/game/block_with_child.dart';
import 'package:block_logic/screens/game/statement_block.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:flutter/material.dart';

// renders block based on data
class BlockRender extends StatelessWidget {
  final GameBlockData data;
  const BlockRender(
    this.data, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    // dPrint('Block-Render: ${data.uid}');
    // dPrint('State: ${data.state.name}\n');
    switch (data.state) {
      case CodeBlockState.inSelector:
        return BlockDesignWrapper(
          data: data,
          child: Center(
            child: BLText(
              data.name,
              size: 14,
              color: data.type == CodeBlockType.keywords ? Colors.black : Colors.white,
            ),
          ),
        );

      case CodeBlockState.inEditor:
        switch (data.type) {
          case CodeBlockType.statement:
            return StatementBox(data: data);
          case CodeBlockType.loops:
          case CodeBlockType.conditionals:
            return BlockDesignWrapper(
              data: data,
              child: GameBlockWithChild(
                box: GameBox.conditions,
                data: data,
              ),
            );
          case CodeBlockType.objects:
          case CodeBlockType.functions:
            if (data.name.contains('def')) {
              return BlockDesignWrapper(
                data: data,
                child: GameBlockWithChild(
                  box: GameBox.parameters,
                  data: data,
                ),
              );
            } else if (data.name.contains('class')) {
              return BlockDesignWrapper(
                data: data,
                child: GameBlockWithChild(
                  data: data,
                ),
              );
            }
            return BlockDesignWrapper(
              data: data,
              child: GameBlockWithChild(
                box: GameBox.arguments,
                data: data,
              ),
            );
          case CodeBlockType.keywords:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return BlockDesignWrapper(
              data: data,
              child: Center(
                child: BLText(
                  data.name,
                  size: 14,
                  color: data.type == CodeBlockType.keywords ? Colors.black : Colors.white,
                ),
              ),
            );
        }
    }
  }
}
