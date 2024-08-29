import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block_with_child.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlock extends ConsumerStatefulWidget {
  final GameBlockData data;
  const GameBlock({required this.data, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameCodeBlockState();
}

class GameCodeBlockState extends ConsumerState<GameBlock> with TickerProviderStateMixin {
  late final GameManager gameManager;
  late final BLUI blui;
  late final String id;
  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerProvider);
    // TODO: animate when cancelled
    return LongPressDraggable(
      delay: const Duration(milliseconds: 100),
      data: '', // drag target will not detect if data is null
      onDragUpdate: (details) {},
      dragAnchorStrategy: (draggable, context, position) {
        return const Offset(-30, 50);
      },
      onDragStarted: () {
        gameManager.passBlockData(widget.data);
        //startPosition = position;
      },
      onDraggableCanceled: (velocity, offset) {
        gameManager.removePassedBlockData();
        gameManager.isDropCancelled(true);
        //_animateBackToStartPosition(offset);
      },
      onDragEnd: (details) {
        // Ensure that the item snaps back only when it's not dropped on a valid DragTarget.
        // if (details.wasAccepted == false) {
        //   _animateBackToStartPosition(details.offset);
        // }
      },
      childWhenDragging: buildBlockState(CodeBlockState.faded),
      feedback: buildBlockState(CodeBlockState.unselected),
      child: buildBlockState(widget.data.state),
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

  Widget buildBlockState(CodeBlockState state) {
    switch (state) {
      case CodeBlockState.unselected:
        debugPrint('${widget.data.name} unselected');
        return BlockDesignWrapper(data: widget.data, child: Center(child: BLText(widget.data.name, size: 14)));
      case CodeBlockState.faded:

        /// if still in the block selector
        if (widget.data.state != CodeBlockState.selected) {
          return BlockDesignWrapper(
            data: widget.data,
            color: blui.getBlockColor(widget.data.type).withAlpha(100),
            child: Center(
                child: BLText(
              widget.data.name,
              size: 14,
            )),
          );
        }

        /// if from inside the editor
        switch (widget.data.type) {
          case CodeBlockType.loops:
          case CodeBlockType.conditionals:
            return BlockDesignWrapper(data: widget.data, child: GameBlockWithChild(data: widget.data));
          case CodeBlockType.objects:
          case CodeBlockType.keywords:
          case CodeBlockType.functions:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return BlockDesignWrapper(data: widget.data, child: Center(child: BLText(widget.data.name, size: 14)));
        }

      case CodeBlockState.selected:
        debugPrint('${widget.data.name} selected');
        switch (widget.data.type) {
          case CodeBlockType.loops:
          case CodeBlockType.conditionals:
            debugPrint('selected');
            return BlockDesignWrapper(data: widget.data, child: GameBlockWithChild(data: widget.data));
          case CodeBlockType.objects:
          case CodeBlockType.keywords:
          case CodeBlockType.functions:
          case CodeBlockType.operators:
          case CodeBlockType.literals:
          case CodeBlockType.variables:
            return BlockDesignWrapper(data: widget.data, child: Center(child: BLText(widget.data.name, size: 14)));
        }
    }
  }

  // Offset position = const Offset(100, 100);
  // Offset startPosition = const Offset(100, 100);
  // late AnimationController _controller;
  // late Animation<Offset> _animation;
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
    super.initState();
  }
}
