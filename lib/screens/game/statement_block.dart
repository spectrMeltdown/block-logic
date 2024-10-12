import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatementBox extends ConsumerWidget {
  final GameBlockData data;
  const StatementBox({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final validator = BlockValidator()
    final gameManager = ref.read(gameManagerProvider.notifier);
    final data = ref.watch(getSelfDataProvider(this.data.uid)); // needed because adding children won't update the UI without it
    final blocks = ref.watch(getChildrenDataProvider(data?.statementUIDs));

    // debugPrint('Statement: ${data?.uid}');
    // debugPrint('Children: ${data?.statementUIDs}');
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            blocks.length,
            (i) {
              // debugPrint('Statement child: ${blocks[i].uid}\n');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GameBlock(
                  key: ValueKey(blocks[i].uid),
                  data: blocks[i],
                ),
              );
            },
          ),
          DragTargetWrapper(
            builderChild: () {
              return const AddNewBlockBox(height: 30, width: 30);
              // return AddNewBlockBox();
            },
            onAcceptWithDetails: (dataToAccept, manager) {
              // debugPrint(initData.toString());
              if (dataToAccept.state == CodeBlockState.inEditor) {
                gameManager.moveData(
                  data: dataToAccept,
                  parent: data!,
                  type: ChildrenData.statementUIDs,
                );
              } else {
                // debugPrint('parent id: ${data!.uid}');
                // debugPrint('initData name: ${initData.name}');
                gameManager.addData(dataToAccept, data!, ChildrenData.statementUIDs);
              }
              ref.invalidate(getRootDataProvider);
              ref.invalidate(getSelfDataProvider);
              ref.invalidate(getChildrenDataProvider);

              // debugPrint(gameManager.getRootData().toString());
            },
            onWillAcceptWithDetails: (dataToAccept) {
              // debugPrint('Self: ${data?.uid}');
              // debugPrint('To accept: ${dataToAccept.uid}');
              if (data?.statementUIDs?.contains(dataToAccept.uid) ?? false || dataToAccept.uid == data?.uid || dataToAccept.uid == data?.parentUID) {
                return false;
              }
              return true;
            },
          )
        ],
      ),
    );
  }
}
