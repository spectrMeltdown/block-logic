import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParameterConditionBox extends ConsumerStatefulWidget {
  final GameBlockData data;
  const ParameterConditionBox({required this.data, super.key});
  @override
  ConsumerState<ParameterConditionBox> createState() => _ParameterConditionBoxState();
}

class _ParameterConditionBoxState extends ConsumerState<ParameterConditionBox> {
  final validator = BlockValidator();
  late final GameManager gameManager;

  @override
  Widget build(BuildContext context) {
    return DragTargetWrapper(
      builderChild: () {
        if (widget.data.parameters != null && widget.data.parameters!.isNotEmpty) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.data.parameters!.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(data: widget.data.parameters![index]),
              );
            }),
          );
        }
        return const BlankWidget();
      },
      onAcceptWithDetails: (data, manager) {
        if (data.state == CodeBlockState.inEditor) {
          gameManager.moveInTree(data, widget.data);
        } else {
          gameManager.addData(data, widget.data, true);
        }
        setState(() {});
      },
      onWillAcceptWithDetails: (data) {
        final isEqual = const ListEquality().equals(data.parameters, widget.data.parameters);
        if (isEqual) {
          return false;
        }
        return true;
        // return validator.parameterBox(data: data!, dataToAccept: data!);
      },
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
