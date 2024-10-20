import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/block_with_child.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBox extends ConsumerWidget {
  final GameBlockData data;
  final GameBox box;
  const CustomBox({required this.data, required this.box, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validator = BlockValidator();
    final data = ref.watch(getSelfDataProvider(this.data.uid))!;
    final gameManager = ref.read(gameManagerProvider.notifier);

    switch (box) {
      case GameBox.parameters:
        final parameters = ref.watch(getChildrenDataProvider(data.parameterUIDs));
        dPrint('Parameters: $parameters');
        return Row(
          children: [
            ...List.generate(parameters.length, (i) {
              if (i != parameters.length - 1) {
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      GameBlock(key: ValueKey(parameters[i].uid), data: parameters[i]),
                      // BLText(','), // TODO: update later
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(key: ValueKey(parameters[i].uid), data: parameters[i]),
              );
            }),
            DragTargetWrapper(
              builderChild: () {
                return const AddNewBlockBox(
                  height: 35,
                  width: 30,
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                // dPrint('Data to accept: ${dataToAccept.name}');
                if (dataToAccept.state == CodeBlockState.inEditor) {
                  gameManager.moveData(
                    data: dataToAccept,
                    parent: data,
                    type: ChildrenData.parameterUIDs,
                  );
                } else {
                  gameManager.addData(dataToAccept, data, ChildrenData.parameterUIDs);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                // setState(() {});
              },
              onWillAcceptWithDetails: (dataToAccept) {
                if (data.parameterUIDs?.contains(dataToAccept.uid) ?? false || dataToAccept.uid == data.uid || dataToAccept.uid == data.parentUID) {
                  return false;
                }
                // return true;
                return validator.parameterBox(data: data, dataToAccept: data); // TODO: update later
              },
            )
          ],
        );
      case GameBox.arguments:
        final arguments = ref.watch(getChildrenDataProvider(data.argumentUIDs));
        dPrint('Arguments: $arguments');
        return Row(children: [
          ...List.generate(arguments.length, (i) {
            debugPrint(arguments.length.toString());
            if (arguments.length > 1 && i != arguments.length - 1) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    GameBlock(key: ValueKey(arguments[i].uid), data: arguments[i]),
                    // BLText(' ,', size: 20), // TODO: update later
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(3),
              child: GameBlock(key: ValueKey(arguments[i].uid), data: arguments[i]),
            );
          }),
          DragTargetWrapper(
            builderChild: () {
              return const AddNewBlockBox(
                height: 35,
                width: 30,
              );
            },
            onAcceptWithDetails: (dataToAccept, manager) {
              if (dataToAccept.state == CodeBlockState.inEditor) {
                gameManager.moveData(
                  data: dataToAccept,
                  parent: data,
                  type: ChildrenData.argumentUIDs,
                );
              } else {
                gameManager.addData(dataToAccept, data, ChildrenData.argumentUIDs);
              }
              ref.invalidate(getRootDataProvider);
              ref.invalidate(getSelfDataProvider);
              ref.invalidate(getChildrenDataProvider);
              // setState(() {});
            },
            onWillAcceptWithDetails: (dataToAccept) {
              if (data.argumentUIDs?.contains(dataToAccept.uid) ?? false || data.uid == dataToAccept.uid) {
                return false;
              }
              // return true;
              return validator.parameterBox(data: data, dataToAccept: dataToAccept);
            },
          )
        ]);

      case GameBox.conditions:
        final conditions = ref.watch(getChildrenDataProvider(data.conditionUIDs));
        dPrint('Conditions: $conditions');
        return Row(
          children: [
            ...List.generate(conditions.length, (i) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(key: ValueKey(conditions[i].uid), data: conditions[i]),
              );
            }),
            DragTargetWrapper(
              builderChild: () {
                return const AddNewBlockBox(
                  height: 35,
                  width: 30,
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                if (dataToAccept.state == CodeBlockState.inEditor) {
                  gameManager.moveData(
                    data: dataToAccept,
                    parent: data,
                    type: ChildrenData.conditionUIDs,
                  );
                } else {
                  gameManager.addData(dataToAccept, data, ChildrenData.conditionUIDs);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                // setState(() {});
              },
              onWillAcceptWithDetails: (dataToAccept) {
                if (data.conditionUIDs?.contains(dataToAccept.uid) ?? false || dataToAccept.uid == data.uid || dataToAccept.uid == data.parentUID) {
                  return false;
                }
                // return true;
                return validator.conditionBox(data: data, dataToAccept: dataToAccept);
              },
            )
          ],
        );
      case GameBox.array:
        final items = ref.watch(getChildrenDataProvider(data.arrayUIDs));
        dPrint('Items: $items');
        return Row(
          children: [
            ...List.generate(items.length, (i) {
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GameBlock(key: ValueKey(items[i].uid), data: items[i]),
              );
            }),
            DragTargetWrapper(
              builderChild: () {
                return const AddNewBlockBox(
                  height: 35,
                  width: 30,
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                if (dataToAccept.state == CodeBlockState.inEditor) {
                  gameManager.moveData(
                    data: dataToAccept,
                    parent: data,
                    type: ChildrenData.arrayUIDs,
                  );
                } else {
                  gameManager.addData(dataToAccept, data, ChildrenData.arrayUIDs);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                // setState(() {});
              },
              onWillAcceptWithDetails: (dataToAccept) {
                if (data.arrayUIDs?.contains(dataToAccept.uid) ?? false || dataToAccept.uid == data.uid || dataToAccept.uid == data.parentUID) {
                  return false;
                }
                // return true;
                return validator.arrayBox(data: data, dataToAccept: dataToAccept);
              },
            )
          ],
        );
    }
  }
}
