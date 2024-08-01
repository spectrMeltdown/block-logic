import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParameterConditionBox extends ConsumerStatefulWidget {
  const ParameterConditionBox({required this.parameters, super.key});
  final List<GameBlockData> parameters;
  @override
  ConsumerState<ParameterConditionBox> createState() =>
      _ParameterConditionBoxState();
}

class _ParameterConditionBoxState extends ConsumerState<ParameterConditionBox> {
  final validator = BlockValidator();
  late final GameManagerState gameManagerState;
  GameBlockData? data;
  bool editorOutline = false;

  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    super.initState();
  }

  void addBlock(GameBlockData block) {}

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerStateProvider);
    return Container(
      decoration: editorOutline
          ? BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white))
          : null,
      child: DragTarget(
        builder: (context, accepted, rejected) {
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
        onAcceptWithDetails: (details) {
          if (data == null) return;
          addBlock(data!);
          gameManagerState.removePassedBlockData();
        },
        onWillAcceptWithDetails: (details) {
          data = gameManagerState.obtainPassedBlockData();
          if (data == null) return false;
          // TODO: customize to accept custom parameters only
          return validator.nestedBox(data: data!, dataToAccept: data!);
        },
        onMove: (details) {},
        onLeave: (details) {},
      ),
    );
  }
}
