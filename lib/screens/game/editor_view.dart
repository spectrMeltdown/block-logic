import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
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
  List<GameBlockData> blockData = [];
  List<int>? childIndexPath;
  bool editorOutline = false;
  bool addedPlaceholder = false;
  // late final GameState GameState;
  final validator = BlockValidator();

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
    final gameState = ref.watch(gameManagerProvider);
    if (gameState.isDropCancelled) {
      // TODO: if drop was cancelled, reverse to previous state of this widget.
      // Use this when animation is applied
      gameManager.isDropCancelled(false);
    }

    setState(() {
      blockData = gameManager.getData(indexPath: []);
    });

    if (blockData.isEmpty) return buildDragTarget();
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
                children: [
                  ...List.generate(blockData.length, (i) {
                    debugPrint(blockData.toString());
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: GameBlock(data: blockData[i]),
                        )
                      ],
                    );
                  }),
                  ConstrainedBox(
                      constraints: BoxConstraints(minWidth: widget.parentConstraints.minWidth, minHeight: 100),
                      child: buildDragTarget()),
                ],
              )
            ],
          )),
    );
  }

  // void addStatement(GameBlockData initial) {
  //   final dataSelected = initial.copyWith(state: CodeBlockState.selected);
  //   blocks.add(StatementBox(
  //     firstBLock: dataSelected,
  //   ));
  // }

  // void addBlock(GameBlockData initial) {
  //   final dataSelected = initial.copyWith(state: CodeBlockState.selected);
  //   blocks.add(GameBlock(data: dataSelected));
  // }

  // void addPlaceholder(GameBlockData data) {
  //   if (addedPlaceholder == true) return;
  //   final dataWithPlaceholder = data.copyWith(state: CodeBlockState.faded);
  //   debugPrint('add placeholder ${dataWithPlaceholder.state}');
  //   blocks.add(GameBlock(data: dataWithPlaceholder));
  //   addedPlaceholder = true;
  // }

  // void removePlaceholder() {
  //   if (addedPlaceholder == true) {
  //     blocks.removeLast();
  //     debugPrint('removed, codeblocks empty = ${blocks.isEmpty}');
  //     addedPlaceholder = false;
  //   }
  // }

  Widget buildDragTarget() {
    return DragTargetWrapper(
      builderChild: () {
        if (blockData.isNotEmpty) {
          return const SizedBox();
        }
        return const Center(child: BLText('Drop a block'));
      },
      onWillAcceptWithDetails: (blockData) {
        /// accept all blockData because this is top-level
        return true;
      },
      onAcceptWithDetails: (block, gameManager) {
        if (block == null) return;
        childIndexPath = gameManager.addData(currentIndexPath: [], data: block);
        setState(() {});
      },
    );
  }
}
