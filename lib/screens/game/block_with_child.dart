import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/parameter_condition_box.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlockWithChild extends ConsumerStatefulWidget {
  const GameBlockWithChild({required this.data, super.key});
  final GameBlockData data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GameBlockWithChildState();
}

class _GameBlockWithChildState extends ConsumerState<GameBlockWithChild> {
  final BlockValidator validator = BlockValidator();
  GameBlockData? block;
  List<Widget> blocks = [];
  bool editorOutline = false;
  List<GameBlockData> parameters = [];

  void addBlock(GameBlockData data) {
    final dataSelected = data.copyWith(state: CodeBlockState.selected);
    debugPrint('add block ${dataSelected.state}');
    blocks.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: GameBlock(data: dataSelected),
        )
      ],
    ));
  }

  void addParameter(GameBlockData data) {
    final dataSelected = data.copyWith(state: CodeBlockState.selected);
    debugPrint('add block ${dataSelected.state}');
    parameters.add(data);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerStateProvider);
    final gameManagerState = ref.watch(gameManagerStateProvider.notifier);

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
                  addParameter(block!);
                  gameManagerState.removePassedBlockData();
                },

                /// Parameters/condition box
                onWillAcceptWithDetails: (details) {
                  block = gameManagerState.obtainPassedBlockData();
                  if (block == null) return false;
                  // TODO: customize to accept custom blocks only
                  if (widget.data.type == CodeBlockType.conditionals) {
                    return validator.statementBox(
                        data: widget.data, dataToAccept: block!);
                  }
                  return validator.parameterBox(
                      data: widget.data, dataToAccept: block!);
                },
                onLeave: (details) {},
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DragTarget(
            builder: (context, accepted, rejected) {
              if (blocks.isNotEmpty) {
                return BlockWrapper(widgetList: blocks);
              }
              return const AddNewBlockBox();
            },
            onAcceptWithDetails: (details) {
              if (block == null) return;
              addBlock(block!);
              gameManagerState.removePassedBlockData();
            },
            onWillAcceptWithDetails: (details) {
              block = gameManagerState.obtainPassedBlockData();
              if (block == null) return false;
              // TODO: customize to accept custom blocks only
              return validator.nestedBox(
                  data: widget.data, dataToAccept: block!);
            },
            onMove: (details) {},
            onLeave: (details) {},
          ),
        )
      ],
    );
  }
}
