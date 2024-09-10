import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block_render.dart';
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
  bool shouldBounce = false;
  // late final String id;
  // late final Widget block;
  @override
  Widget build(BuildContext context) {
    // TODO: animate when cancelled
    return Draggable<GameBlockData>(
      // delay: const Duration(milliseconds: 100),
      data: widget.data, // drag target will not detect if data is null
      onDragUpdate: (details) {},
      dragAnchorStrategy: (draggable, context, position) {
        return const Offset(-30, 50);
      },
      onDragStarted: () {
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
        // Ensure that the item snaps back only when it's not dropped on a valid DragTarget.
        // if (details.wasAccepted == false) {
        //   _animateBackToStartPosition(details.offset);
        // }
      },
      childWhenDragging: BlockRender(widget.data),
      feedback: BlockRender(widget.data), // the widget that follws the touch position
      child: BlockRender(widget.data), // the normal display
      // childWhenDragging: buildBlockState(CodeBlockState.faded),
      // feedback: buildBlockState(CodeBlockState.unselected),
      // child: buildBlockState(widget.data.state),
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
