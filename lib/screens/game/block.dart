import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/custom_tab.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/return_block.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:block_logic/logic/services/should_reset_block.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class GameBlock extends ConsumerStatefulWidget {
  final GameBlockData data;
  final void Function({bool add})? updateStackCount;
  final void Function()? resetCount;
  const GameBlock({required this.data, this.updateStackCount, this.resetCount, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameCodeBlockState();
}

class GameCodeBlockState extends ConsumerState<GameBlock> with TickerProviderStateMixin {
  late final GameManager gameManager;
  late final BLUI blui;
  // bool firstBuild = true;
  bool shouldBounce = false;
  bool shouldResetSelf = false;
  // late final String id;
  late Widget block;
  late Widget defaultWithPadding;
  GameBlockData? finalData;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    blui = ref.read(bLUIProvider.notifier);
    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // _controller.addListener(() {
    //   setState(() {
    //     position = _animation.value;
    //   });
    // });
    defaultWithPadding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: BlockRender(widget.data, refresh),
    );
    if (widget.data.state == CodeBlockState.inSelector) {
      // debugPrint('Built as inSelector');
      block = defaultWithPadding;
      finalData = widget.data.copyWith(inSelectorUID: gameManager.getUID());
      gameManager.addInSelectorUIDs(finalData!.type, finalData!.inSelectorUID!);
    } else {
      block = BlockRender(widget.data, refresh);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.data.state == CodeBlockState.inSelector && firstBuild) {
    //   debugPrint('firstBuild');
    //   gameManager.incrementCategory(widget.data.type);
    //   ref.invalidate(customTabProvider);
    //   setState(() {
    //     firstBuild = false;
    //   });
    // }
    final shouldResetFromAll = ref.watch(shouldResetAllBlocksProvider);
    if (widget.data.state == CodeBlockState.inSelector) {
      shouldResetSelf = ref.watch(
        shouldResetBlockProvider(
          Tuple2(finalData!.type, finalData!.inSelectorUID!),
        ),
      );
      if (shouldResetFromAll) {
        debugPrint('shouldResetFromAll');
        setState(() {
          block = defaultWithPadding;
        });
        gameManager.resetAllCategory();
        Future.delayed(Duration.zero, () {
          gameManager.incrementCategory(widget.data.type);
          ref.invalidate(customTabProvider);
        });
        Future.delayed(Duration.zero, () {
          gameManager.setShouldResetAllBlocks(false);
          ref.invalidate(shouldResetAllBlocksProvider);
        });
      } else if (shouldResetSelf) {
        debugPrint('shouldResetSelf');
        setState(() {
          block = defaultWithPadding;
        });
        if (widget.updateStackCount != null) {
          // widget.resetCount!();
          widget.updateStackCount!(add: true);
        }
        gameManager.addInSelectorUIDs(finalData!.type, finalData!.inSelectorUID!);
        gameManager.incrementCategory(widget.data.type);
        ref.invalidate(customTabProvider);
        ref.invalidate(shouldResetBlockProvider);
      }
    }
    // TODO: animate when cancelled
    return LongPressDraggable<GameBlockData>(
        delay: const Duration(milliseconds: 100),
        data: finalData ?? widget.data, // drag target will not detect if data is null
        onDragUpdate: (details) {},
        dragAnchorStrategy: (draggable, context, position) {
          return const Offset(-30, 50);
        },
        onDragStarted: () {
          if (widget.data.state == CodeBlockState.inEditor) {
            gameManager.toggleReturnBlock(true);
            ref.invalidate(returnBlockProvider);
          }
          // TODO: add bouncing animation on feedback,
          // gameManager.passBlockData(widget.data);
          //startPosition = position;
        },
        onDraggableCanceled: (velocity, offset) {
          // gameManager.removePassedBlockData();
          // gameManager.isDropCancelled(true);
          //_animateBackToStartPosition(offset);
        },
        onDragEnd: (details) {
          if (widget.data.state == CodeBlockState.inEditor) {
            gameManager.toggleReturnBlock(false);
            ref.invalidate(returnBlockProvider);
          }
          // Ensure that the item snaps back only when it's not dropped on a valid DragTarget.
          // if (details.wasAccepted == false) {
          //   _animateBackToStartPosition(details.offset);
          // }
        },
        onDragCompleted: () {
          if (widget.data.state == CodeBlockState.inSelector) {
            if (widget.data.inSelectorCount != null) {
              widget.updateStackCount!(add: false);
            }
            debugPrint('Decrement ${widget.data.type}');
            gameManager.decrementCategory(widget.data.type);
            ref.invalidate(customTabProvider);
            setState(() {
              block = const BlankWidget();
            });
          }
        },
        childWhenDragging: AnimatedOpacity(
          opacity: 0.3,
          duration: Duration.zero,
          child: block,
        ),
        feedback: Transform.scale(scale: 0.8, child: block), // the widget that follws the touch position
        child: block

        // the normal display
        // childWhenDragging: buildBlockState(CodeBlockState.faded),
        // feedback: buildBlockState(CodeBlockState.unselected),
        // child: buildBlockState(widget.data),
        );
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // void _animateBackToStartPosition(Offset offset) {
  //   _animation =
  //       Tween<Offset>(begin: offset, end: startPosition).animate(_controller);
  //   _controller.forward(from: 0.0);
  // }

  // Offset position = const Offset(100, 100);
  // Offset startPosition = const Offset(100, 100);
  // late AnimationController _controller;
  // late Animation<Offset> _animation;
}
