import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/parameter_condition_box.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_blocks.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlockWithChild extends ConsumerStatefulWidget {
  final GameBlockData data;
  const GameBlockWithChild({required this.data, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameBlockWithChildState();
}

class _GameBlockWithChildState extends ConsumerState<GameBlockWithChild> {
  final BlockValidator validator = BlockValidator();
  late final GameManager gameManager;

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BLText(data.name),
            const SizedBox(width: 20),

            /// Parameter/condition box
            DragTargetWrapper(
              builderChild: () {
                if (data.parameters != null && data.parameters!.isNotEmpty) {
                  return ParameterConditionBox(
                    data: data,
                  );
                }
                return const SizedBox(width: 80, height: 40);
              },
              onAcceptWithDetails: (block, manager) {},

              /// Parameters/condition box
              onWillAcceptWithDetails: (data) {
                if (data.type == CodeBlockType.conditionals) {
                  return validator.statementBox(data: data, dataToAccept: data);
                }
                return validator.parameterBox(data: data, dataToAccept: data);
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DragTargetWrapper(
            builderChild: () {
              if (data.body != null && data.body!.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlockWrapper(
                        widgetList: List.generate(
                            data.body!.length,
                            (i) => GameBlock(
                                  data: data.body![i],
                                ))),
                    const AddNewBlockBox()
                  ],
                );
              }
              return const AddNewBlockBox();
            },
            onAcceptWithDetails: (initData, manager) {
              if (initData.state == CodeBlockState.inEditor) {
                gameManager.moveInTree(initData, data);
              } else {
                gameManager.addData(initData, data);
              }
              ref.invalidate(getRootDataProvider);
              setState(() {});
            },
            onWillAcceptWithDetails: (initData) {
              if (initData.indexPath != null) {
                bool sameIndexPath = const ListEquality().equals(initData.indexPath, data.indexPath);
                if (sameIndexPath) {
                  return false;
                }
              }
              return true;
              // return validator.nestedBox(data: data, dataToAccept: initData);
            },
          ),
        )
      ],
    );
  }
}
