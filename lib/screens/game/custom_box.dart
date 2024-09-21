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
        final data = ref.watch(getSelfDataProvider(widget.data.uid!));
        final parameters = ref.watch(getChildrenDataProvider(data!.parameterUIDs));
        return Row(
          children: [
            ...List.generate(parameters!.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(data: parameters[index]),
              );
            }),
            DragTargetWrapper(
              builderChild: () {
                if (parameters.isNotEmpty) {}
                return const AddNewBlockBox(
                  height: 40,
                  width: 100,
                );
              },
              onAcceptWithDetails: (data, manager) {
                if (data.state == CodeBlockState.inEditor) {
                  gameManager.moveData(data.uid!, widget.data.uid!);
                } else {
                  gameManager.addData(data, widget.data.uid!, ChildrenData.parameters);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                setState(() {});
              },
              onWillAcceptWithDetails: (data) {
                if (widget.data.parameterUIDs!.contains(data.uid) || data.uid == widget.data.uid) {
                  return false;
                }
                return true;
                // return validator.parameterBox(data: data!, dataToAccept: data!);
              },
            )
          ],
        );
      case GameBox.arguments:
        final data = ref.watch(getSelfDataProvider(widget.data.uid!));
        final arguments = ref.watch(getChildrenDataProvider(data!.argumentUIDs!));
        return DragTargetWrapper(
          builderChild: () {
            if (arguments!.isNotEmpty) {
              return Row(
                children: List.generate(arguments.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: GameBlock(data: arguments[index]),
                  );
                }),
              );
            }
            return const AddNewBlockBox(
              height: 40,
            );
          },
          onAcceptWithDetails: (data, manager) {
            if (data.state == CodeBlockState.inEditor) {
              gameManager.moveData(data.uid!, widget.data.uid!);
            } else {
              gameManager.addData(data, widget.data.uid!, ChildrenData.arguments);
            }
            ref.invalidate(getRootDataProvider);
            ref.invalidate(getChildrenDataProvider);
            ref.invalidate(getSelfDataProvider);
            setState(() {});
          },
          onWillAcceptWithDetails: (data) {
            if (widget.data.argumentUIDs!.contains(data.uid) || data.uid == widget.data.uid) {
              return false;
            }
            return true;
            // return validator.parameterBox(data: data!, dataToAccept: data!);
          },
        );
      case GameBox.conditions:
        final data = ref.watch(getSelfDataProvider(widget.data.uid!));
        final conditions = ref.watch(getChildrenDataProvider(data!.conditionUIDs!));

        return Row(
          children: [
            ...List.generate(conditions!.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(data: conditions[index]),
              );
            }),
            DragTargetWrapper(
              builderChild: () {
                return AddNewBlockBox(
                  height: 35,
                  width: conditions.isEmpty ? 100 : 30,
                );
              },
              onAcceptWithDetails: (data, manager) {
                if (data.state == CodeBlockState.inEditor) {
                  gameManager.moveData(data.uid!, widget.data.uid!);
                } else {
                  gameManager.addData(data, widget.data.uid!, ChildrenData.condition);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                setState(() {});
              },
              onWillAcceptWithDetails: (data) {
                if (widget.data.conditionUIDs!.contains(data.uid) ||
                    data.uid == widget.data.uid ||
                    data.uid == widget.data.parentUID) {
                  return false;
                }
                return validator.conditionBox(data: widget.data, dataToAccept: data);
              },
            )
          ],
        );
      case GameBox.array:
        final data = ref.watch(getSelfDataProvider(widget.data.uid!));
        final items = ref.watch(getChildrenDataProvider(data!.arrayUIDs!));

        return Row(
          children: [
            ...List.generate(items!.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(data: items[index]),
              );
            }),
            DragTargetWrapper(
              builderChild: () {
                return AddNewBlockBox(
                  height: 35,
                  width: items.isEmpty ? 100 : 30,
                );
              },
              onAcceptWithDetails: (data, manager) {
                if (data.state == CodeBlockState.inEditor) {
                  gameManager.moveData(data.uid!, widget.data.uid!);
                } else {
                  gameManager.addData(data, widget.data.uid!, ChildrenData.array);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                setState(() {});
              },
              onWillAcceptWithDetails: (data) {
                if (widget.data.arrayUIDs!.contains(data.uid) ||
                    data.uid == widget.data.uid ||
                    data.uid == widget.data.parentUID) {
                  return false;
                }
                return validator.conditionBox(data: widget.data, dataToAccept: data);
              },
            )
          ],
        );
    }
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
