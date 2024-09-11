import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/block_with_child.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBox extends ConsumerStatefulWidget {
  final GameBlockData data;
  final GameBox box;
  const CustomBox({required this.data, required this.box, super.key});
  @override
  ConsumerState<CustomBox> createState() => _ParameterConditionBoxState();
}

class _ParameterConditionBoxState extends ConsumerState<CustomBox> {
  final validator = BlockValidator();
  late final GameManager gameManager;

  @override
  Widget build(BuildContext context) {
    switch (widget.box) {
      case GameBox.parameters:
        // TODO: update later
        final parameters = ref.watch(GetChildrenDataProvider(widget.data.parameterUIDs!));
        return DragTargetWrapper(
          builderChild: () {
            if (parameters.isNotEmpty) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(parameters.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: GameBlock(data: parameters[index]),
                  );
                }),
              );
            }
            return AddNewBlockBox(
              height: 40,
            );
          },
          onAcceptWithDetails: (data, manager) {
            if (data.state == CodeBlockState.inEditor) {
              gameManager.moveData(data.uid!, widget.data.uid!);
            } else {
              gameManager.addData(data, widget.data.uid!, ChildrenData.parameters);
            }
            ref.invalidate(getSelfDataProvider);
            setState(() {});
          },
          onWillAcceptWithDetails: (data) {
            if (widget.data.conditionUIDs!.contains(data.uid) || data.uid == widget.data.uid) {
              return false;
            }
            return true;
            // return validator.parameterBox(data: data!, dataToAccept: data!);
          },
        );
      case GameBox.arguments:
        final arguments = ref.watch(GetChildrenDataProvider(widget.data.argumentUIDs!));
        return DragTargetWrapper(
          builderChild: () {
            if (arguments.isNotEmpty) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(arguments.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: GameBlock(data: arguments[index]),
                  );
                }),
              );
            }
            return AddNewBlockBox(
              height: 40,
            );
          },
          onAcceptWithDetails: (data, manager) {
            if (data.state == CodeBlockState.inEditor) {
              gameManager.moveData(data.uid!, widget.data.uid!);
            } else {
              gameManager.addData(data, widget.data.uid!, ChildrenData.arguments);
            }
            ref.invalidate(getSelfDataProvider);
            setState(() {});
          },
          onWillAcceptWithDetails: (data) {
            if (widget.data.conditionUIDs!.contains(data.uid) || data.uid == widget.data.uid) {
              return false;
            }
            return true;
            // return validator.parameterBox(data: data!, dataToAccept: data!);
          },
        );
      case GameBox.conditions:
        final conditions = ref.watch(GetChildrenDataProvider(widget.data.conditionUIDs!));
        return DragTargetWrapper(
          builderChild: () {
            if (conditions.isNotEmpty) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(conditions.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: GameBlock(data: conditions[index]),
                  );
                }),
              );
            }
            return AddNewBlockBox(
              height: 40,
            );
          },
          onAcceptWithDetails: (data, manager) {
            if (data.state == CodeBlockState.inEditor) {
              gameManager.moveData(data.uid!, widget.data.uid!);
            } else {
              gameManager.addData(data, widget.data.uid!, ChildrenData.condition);
            }
            ref.invalidate(getSelfDataProvider);
            setState(() {});
          },
          onWillAcceptWithDetails: (data) {
            if (widget.data.conditionUIDs!.contains(data.uid) || data.uid == widget.data.uid) {
              return false;
            }
            return true;
            // return validator.parameterBox(data: data!, dataToAccept: data!);
          },
        );
    }
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
