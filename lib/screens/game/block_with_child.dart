import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/custom_box.dart';
import 'package:block_logic/screens/game/wrapper_blocks.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GameBox { parameters, arguments, conditions, array }

class GameBlockWithChild extends ConsumerWidget {
  final GameBlockData data;
  final GameBox? box;

  const GameBlockWithChild({
    required this.data,
    this.box,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.read(gameManagerProvider.notifier);
    final data = ref.watch(getSelfDataProvider(this.data.uid!))!;
    final bodyData = ref.watch(getChildrenDataProvider(data.bodyUIDs));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BLText(data.name),
            const SizedBox(
              width: 5,
            ),
            if (shouldRenderParentheses(data))
              const BLText(
                '(',
                size: 20,
              ),
            if (shouldRenderBox(data))
              CustomBox(
                data: data,
                box: box!,
              ),
            if (shouldRenderParentheses(data))
              const BLText(
                ')',
                size: 20,
              ),
            if (shouldRenderColon(data))
              const BLText(
                ':',
                size: 20,
              ),
            // if (widget.data.bodyUIDs != null) const BLText(' :')
          ],
        ),
        if (data.bodyUIDs != null)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlockWrapper(
                  widgetList: List.generate(
                    bodyData.length,
                    (i) => GameBlock(
                      key: ValueKey(bodyData[i].uid),
                      data: bodyData[i],
                    ),
                  ),
                ),
                DragTargetWrapper(
                  builderChild: () {
                    return const AddNewBlockBox(width: 120);
                  },
                  onAcceptWithDetails: (dataToAccept, manager) {
                    if (dataToAccept.state == CodeBlockState.inEditor) {
                      gameManager.moveData(
                        data: dataToAccept,
                        parent: data,
                        type: ChildrenData.bodyUIDs,
                      );
                    } else {
                      // dPrint('Parent: ${widget.data.uid}');
                      gameManager.addData(dataToAccept, data, ChildrenData.bodyUIDs);
                    }
                    ref.invalidate(getRootDataProvider);
                    ref.invalidate(getSelfDataProvider);
                    ref.invalidate(getChildrenDataProvider);
                    // setState(() {});
                  },
                  onWillAcceptWithDetails: (dataToAccept) {
                    if (data.bodyUIDs?.contains(dataToAccept.uid) ?? false || dataToAccept.uid == data.uid || dataToAccept.uid == data.parentUID) {
                      return false;
                    }
                    return true;
                    // return validator.bodyBox(data: widget.data, dataToAccept: initData);
                  },
                )
              ],
            ),
          )
      ],
    );
  }

  bool shouldRenderParentheses(GameBlockData data) {
    // if (data.name == 'else') return false;
    // if (data.name.contains('class')) return false;
    if (data.argumentUIDs != null || data.parameterUIDs != null) return true;
    return false;
  }

  bool shouldRenderBox(GameBlockData data) {
    if (data.name == 'else') return false;
    if (data.name.contains('class')) return false;
    return true;
  }

  bool shouldRenderColon(GameBlockData data) {
    switch (data.type) {
      case CodeBlockType.functions:
        if (data.name.substring(0, 3).contains('def')) {
          return true;
        }
      case CodeBlockType.objects:
        if (data.name.substring(0, 5).contains('class')) {
          return true;
        }
      case CodeBlockType.conditionals:
      case CodeBlockType.loops:
        return true;
      case CodeBlockType.operators:
      case CodeBlockType.keywords:
      case CodeBlockType.literals:
      case CodeBlockType.variables:
      case CodeBlockType.statement:
    }
    return false;
  }
}
