import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorView extends ConsumerStatefulWidget {
  final BoxConstraints parentConstraints;
  const EditorView({required this.parentConstraints, super.key});
  @override
  ConsumerState<EditorView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends ConsumerState<EditorView> with AutomaticKeepAliveClientMixin {
  List<int>? childIndexPath;
  bool editorOutline = false;
  bool addedPlaceholder = false;
  final validator = BlockValidator();
  late GameState gameState;

  @override
  bool get wantKeepAlive => true;

  late final GameManager gameManager;

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    gameState = ref.watch(gameManagerProvider);
    final blockData = ref.watch(getRootDataProvider);
    // final blockData = gameManager.getRootData();
    // if (gameState.isDropCancelled) {
    //   // TODO: if drop was cancelled, reverse to previous state of this widget.
    //   // Use this when animation is applied
    //   gameManager.isDropCancelled(false);
    // }
    if (blockData.isEmpty) return buildDragTarget([]);
    // final parentRenderBox = widget.editorWidgetKey.currentContext!.findRenderObject() as RenderBox;
    // final parentSize = parentRenderBox.size;
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(blockData.length, (i) {
                    // debugPrint(blockData.toString());
                    return GameBlock(data: blockData[i]);
                  }),
                  ConstrainedBox(constraints: BoxConstraints(minWidth: widget.parentConstraints.minWidth, minHeight: widget.parentConstraints.minHeight), child: buildDragTarget(blockData)),
                ],
              )
            ],
          )),
    );
  }

  Widget buildDragTarget(List<GameBlockData> blockData) {
    // debugPrint(gameState.dataTree.toString());
    List<String> rootBlockIDs = [];
    for (final block in blockData) {
      rootBlockIDs.add(block.uid!);
    }
    return DragTargetWrapper(
      builderChild: () {
        if (blockData.isNotEmpty) {
          return const SizedBox();
        }
        return const Center(child: BLText('Drop a block'));
      },
      onWillAcceptWithDetails: (dataToAccept) {
        if (rootBlockIDs.contains(dataToAccept.uid)) {
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
        setState(() {});
      },
    );
  }
}
