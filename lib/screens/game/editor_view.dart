import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorView extends ConsumerStatefulWidget {
  final GlobalKey editorWidgetKey;
  const EditorView({required this.editorWidgetKey, super.key});
  @override
  ConsumerState<EditorView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends ConsumerState<EditorView>
    with AutomaticKeepAliveClientMixin {
  List<Widget> blocks = [];
  List<GameBlockData> blocksData = [];
  bool editorOutline = false;
  bool addedPlaceholder = false;
  // late final GameState GameState;
  final validator = BlockValidator();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final gameManager = ref.read(gameManagerProvider.notifier);
    final gameState = ref.watch(gameManagerProvider);

    /// get the block
    blocksData = [];
    //     GameState.getBlockData([], isTopLevel: true).map((item) {
    //   return item as GameBlockData;
    // }).toList();
    // blocks = blocksData.map((data){
    //   if () {
    //       blocks.add(StatementBox(
    //   firstBLock: dataSelected,
    // ));
    //   }
    // }).toList();
    if (gameState.isDropCancelled) {
      // TODO: if drop was cancelled, reverse to previous state of this widget.
      // Use this when animation is applied
      gameManager.isDropCancelled(false);
    }

    if (blocks.isEmpty) return buildDragTarget();

    final parentRenderBox =
        widget.editorWidgetKey.currentContext!.findRenderObject() as RenderBox;
    final parentSize = parentRenderBox.size;

    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                      width: parentSize.width * 0.893,
                      height: parentSize.height * 0.95,
                      child: buildDragTarget());
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(blocks.length, (i) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: blocks[i],
                        )
                      ],
                    );
                  }),
                ],
              ),
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
        if (blocks.isNotEmpty) {
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
        //GameState.addData(currentIndexPath: [], data: block);
      },
    );
    // return Container(
    //   decoration: editorOutline
    //       ? BoxDecoration(
    //           borderRadius: const BorderRadius.all(Radius.circular(10)),
    //           border: Border.all(color: Colors.white))
    //       : null,
    //   child: DragTarget(
    //     // rejected bypasses onMove
    //     builder: (context, accepted, rejected) {},
    //     onWillAcceptWithDetails: (details) {
    //       block = GameState.obtainBlockData();
    //       if (block == null) return false;
    //       setState(() {
    //         editorOutline = true;
    //       });
    //       return true;
    //       // if (validator.topLevelBox(block!)) {
    //       //   return true;
    //       // }
    //       // return false;
    //     },
    //     onAcceptWithDetails: (details) {
    //       setState(() {
    //         editorOutline = false;
    //       });
    //       if (block == null) return;
    //       if (validator.rootStatementBox(data: block!)) {
    //         addStatement(block!);
    //       } else {
    //         addBlock(block!);
    //       }
    //       GameState.removePassedBlockData();
    //     },
    //     onLeave: (details) {
    //       setState(() {
    //         editorOutline = false;
    //       });
    //     },
    //   ),
    // );
  }
}
