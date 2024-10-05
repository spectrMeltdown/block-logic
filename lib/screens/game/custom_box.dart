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

class CustomBox extends ConsumerWidget {
  final GameBlockData data;
  final GameBox box;
  const CustomBox({required this.data, required this.box, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validator = BlockValidator();
    // final data = ref.watch(getSelfDataProvider(this.data.uid));
    final gameManager = ref.read(gameManagerProvider.notifier);
    switch (box) {
      case GameBox.parameters:
        final parameters = ref.watch(getChildrenDataProvider(data.parameterUIDs ?? []));
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
                return const AddNewBlockBox(
                  height: 35,
                  width: 30,
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                if (dataToAccept.state == CodeBlockState.inEditor) {
                  // gameManager.moveData(dataToAccept, data.uid!, ChildrenData.parameters);
                } else {
                  gameManager.addData(dataToAccept, data.uid!, ChildrenData.parameters);
                }
                ref.invalidate(getRootDataProvider);
                ref.invalidate(getSelfDataProvider);
                ref.invalidate(getChildrenDataProvider);
                // setState(() {});
              },
              onWillAcceptWithDetails: (dataToAccept) {
                if (data.parameterUIDs?.contains(dataToAccept.uid) ?? false || dataToAccept.uid == data.uid) {
                  return false;
                }
                return true;
                // return validator.parameterBox(data: data!, dataToAccept: data!);
              },
            )
          ],
        );
      case GameBox.arguments:
        final arguments = ref.watch(getChildrenDataProvider(data.argumentUIDs ?? []));
        return Row(children: [
          ...List.generate(arguments!.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(3),
              child: GameBlock(data: arguments[index]),
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
                // gameManager.moveData(dataToAccept, data.uid!, ChildrenData.arguments);
              } else {
                gameManager.addData(dataToAccept, data.uid!, ChildrenData.arguments);
              }
              ref.invalidate(getRootDataProvider);
              ref.invalidate(getChildrenDataProvider);
              ref.invalidate(getSelfDataProvider);
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
        final conditions = ref.watch(getChildrenDataProvider(data.conditionUIDs ?? []));

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
                return const AddNewBlockBox(
                  height: 35,
                  width: 30,
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                if (dataToAccept.state == CodeBlockState.inEditor) {
                  // gameManager.moveData(dataToAccept, data.uid!, ChildrenData.condition);
                } else {
                  gameManager.addData(dataToAccept, data.uid!, ChildrenData.condition);
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
        final items = ref.watch(getChildrenDataProvider(data.arrayUIDs ?? []));

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
                return const AddNewBlockBox(
                  height: 35,
                  width: 30,
                );
              },
              onAcceptWithDetails: (dataToAccept, manager) {
                if (dataToAccept.state == CodeBlockState.inEditor) {
                  // gameManager.moveData(dataToAccept, data.uid!, ChildrenData.array);
                } else {
                  gameManager.addData(dataToAccept, data.uid!, ChildrenData.array);
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
                return validator.conditionBox(data: data, dataToAccept: dataToAccept);
              },
            )
          ],
        );
    }
  }
}
