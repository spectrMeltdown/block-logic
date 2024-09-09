import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParameterConditionBox extends ConsumerStatefulWidget {
  final List<GameBlockData> parameters;
  const ParameterConditionBox({required this.parameters, super.key});
  @override
  ConsumerState<ParameterConditionBox> createState() => _ParameterConditionBoxState();
}

class _ParameterConditionBoxState extends ConsumerState<ParameterConditionBox> {
  final validator = BlockValidator();
  late final GameManager gameManager;
  GameBlockData? data;
  bool editorOutline = false;

  void addBlock(GameBlockData block) {}

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerProvider);
    return Container(
      decoration: editorOutline
          ? BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white))
          : null,
      child: DragTargetWrapper(
        builderChild: () {
          if (widget.parameters.isNotEmpty) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widget.parameters.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: GameBlock(data: widget.parameters[index]),
                );
              }),
            );
          }
          return const BlankWidget();
        },
        onAcceptWithDetails: (data, manager) {
          if (data == null) return;
          gameManager.addData(data);
          gameManager.removePassedBlockData();
          setState(() {});
        },
        onWillAcceptWithDetails: (details) {
          data = gameManager.obtainPassedBlockData();
          if (data == null) return false;
          // TODO: customize to accept custom parameters only
          return validator.nestedBox(data: data!, dataToAccept: data!);
        },
      ),
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
