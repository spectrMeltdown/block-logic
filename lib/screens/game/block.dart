import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlock extends ConsumerStatefulWidget {
  final GameBlockData data;
  final void Function({bool add})? updateCount;
  const GameBlock({required this.data, this.updateCount, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameCodeBlockState();
}

class GameCodeBlockState extends ConsumerState<GameBlock> with TickerProviderStateMixin {
  late final GameManager gameManager;
  late final BLUI blui;
  bool shouldBounce = false;
  // late final String id;
  late Widget block;
  late Widget defaultWithPadding;
  bool? shouldReset;

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
      block = defaultWithPadding;
    } else {
      block = BlockRender(widget.data, refresh);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shouldReset = ref.watch(gameManagerProvider.select((a) => a.dataTree.isEmpty));
    if (widget.data.state == CodeBlockState.inSelector) {
      if (shouldReset!) {
        setState(() {
          block = defaultWithPadding;
        });
      }
    }
    // TODO: animate when cancelled
    return LongPressDraggable<GameBlockData>(
        delay: const Duration(milliseconds: 150),
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
        onDragCompleted: () {
          if (widget.data.state == CodeBlockState.inSelector) {
            if (widget.data.inSelectorCount != null) {
              widget.updateCount!(add: false);
            }
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
}
