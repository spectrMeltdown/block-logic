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
    final blockData = ref.watch(GetBlockDataProvider(widget.data.indexPath!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BLText(widget.data.name),
            const SizedBox(width: 20),

            /// Parameter/condition box
            DragTargetWrapper(
              builderChild: () {
                if (blockData.parameters != null && blockData.parameters!.isNotEmpty) {
                  return ParameterConditionBox(
                    parameters: blockData.parameters!,
                  );
                }
                return const SizedBox(width: 80, height: 40);
              },
              onAcceptWithDetails: (block, manager) {
                if (block == null) return;
                // addParameter(block!);
                // gameManager.removePassedBlockData();
              },

              /// Parameters/condition box
              onWillAcceptWithDetails: (data) {
                data = gameManager.obtainPassedBlockData();
                if (data == null) return false;
                // TODO: customize to accept custom blocks only
                if (widget.data.type == CodeBlockType.conditionals) {
                  return validator.statementBox(data: widget.data, dataToAccept: data);
                }
                return validator.parameterBox(data: widget.data, dataToAccept: data);
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DragTargetWrapper(
            builderChild: () {
              if (blockData.body != null && blockData.body!.isNotEmpty) {
                return BlockWrapper(
                    widgetList: List.generate(
                        blockData.body!.length,
                        (i) => GameBlock(
                              data: blockData.body![i],
                            )));
              }
              return const AddNewBlockBox();
            },
            onAcceptWithDetails: (initData, manager) {
              if (initData == null) return;
              final data = initData.copyWith(indexPath: widget.data.indexPath);
              gameManager.addData(data);
              // setState(() {});
            },
            onWillAcceptWithDetails: (data) {
              if (data == null) return false;
              // TODO: customize to accept custom blocks only
              return true;
              // return validator.nestedBox(data: widget.data, dataToAccept: block!);
            },
          ),
        )
      ],
    );
  }
}
