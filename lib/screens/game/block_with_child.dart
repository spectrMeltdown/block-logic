import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/parameter_condition_box.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_blocks.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlockWithChild extends ConsumerStatefulWidget {
  final GameBlockData data;
  final List<int> indexPath;
  const GameBlockWithChild({required this.indexPath, required this.data, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameBlockWithChildState();
}

class _GameBlockWithChildState extends ConsumerState<GameBlockWithChild> {
  final BlockValidator validator = BlockValidator();
  late final GameManager gameManager;
  GameBlockData? block;
  List<GameBlockData> blockData = [];
  bool editorOutline = false;
  List<GameBlockData> parameters = [];

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerProvider);
    setState(() {
      blockData = gameManager.getData(indexPath: widget.indexPath);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BLText(widget.data.name),
            const SizedBox(width: 20),

            /// Parameter/condition box
            Container(
              decoration: editorOutline
                  ? BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.white))
                  : null,
              child: DragTarget(
                builder: (context, accepted, rejected) {
                  if (parameters.isNotEmpty) {
                    return ParameterConditionBox(
                      parameters: parameters,
                    );
                  }
                  return const SizedBox(width: 80, height: 40);
                },
                onAcceptWithDetails: (details) {
                  if (block == null) return;
                  // addParameter(block!);
                  // gameManager.removePassedBlockData();
                },

                /// Parameters/condition box
                onWillAcceptWithDetails: (details) {
                  block = gameManager.obtainPassedBlockData();
                  if (block == null) return false;
                  // TODO: customize to accept custom blocks only
                  if (widget.data.type == CodeBlockType.conditionals) {
                    return validator.statementBox(data: widget.data, dataToAccept: block!);
                  }
                  return validator.parameterBox(data: widget.data, dataToAccept: block!);
                },
                onLeave: (details) {},
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DragTargetWrapper(
            builderChild: () {
              if (blockData.isNotEmpty) {
                return BlockWrapper(
                    widgetList: List.generate(
                        blockData.length,
                        (i) => GameBlock(
                              indexPath: childIndex,
                              data: blockData[i],
                            )));
              }
              return const AddNewBlockBox();
            },
            onAcceptWithDetails: (data, manager) {
              if (block == null) return;
              childIndex = gameManager.addData(currentIndexPath: widget.indexPath, data: block!);
              gameManager.removePassedBlockData();
            },
            onWillAcceptWithDetails: (details) {
              block = gameManager.obtainPassedBlockData();
              if (block == null) return false;
              // TODO: customize to accept custom blocks only
              return validator.nestedBox(data: widget.data, dataToAccept: block!);
            },
          ),
        )
      ],
    );
  }
}
