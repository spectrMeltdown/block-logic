import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorView extends ConsumerWidget {
  final BoxConstraints parentConstraints;
  const EditorView({required this.parentConstraints, super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final validator = BlockValidator();
    final blockData = ref.watch(getRootDataProvider);
    // dPrint(blockData.toString());
    Widget buildDragTarget(List<GameBlockData> blockData) {
      // dPrint(gameState.dataTree.toString());
      return DragTargetWrapper(
        builderChild: () {
          if (blockData.isNotEmpty) {
            return const SizedBox();
          }
          return const Center(child: BLText('Drop a block'));
        },
        onWillAcceptWithDetails: (dataToAccept) {
          if (blockData.any((i) => i.uid == dataToAccept.uid)) {
            return false;
          }
          return true;
        },
        onAcceptWithDetails: (dataToAccept, gameManager) {
          if (dataToAccept.state == CodeBlockState.inEditor) {
            // gameManager.moveToRoot(initData.uid!);
            gameManager.moveToRoot(dataToAccept.uid!);
          } else {
            gameManager.addRootData(dataToAccept);
          }
          ref.invalidate(getRootDataProvider);
          ref.invalidate(getSelfDataProvider);
          ref.invalidate(getChildrenDataProvider);
          // for (final entry in ref.read(gameManagerProvider).dataTree.entries) {
          //   dPrint(entry.toString());
          // }

          // setState(() {});
        },
      );
    }

    if (blockData.isEmpty) return buildDragTarget([]);

    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...List.generate(blockData.length, (i) {
                // dPrint('Editor View: ${blockData[i].uid}\n');
                return GameBlock(
                  key: ValueKey(blockData[i].uid),
                  data: blockData[i],
                );
              }),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: parentConstraints.minWidth,
                  minHeight: parentConstraints.minHeight,
                ),
                child: buildDragTarget(blockData),
              ),
            ],
          )),
    );
  }
}
