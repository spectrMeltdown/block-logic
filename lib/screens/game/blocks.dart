import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameCodeBlock extends ConsumerStatefulWidget {
  const GameCodeBlock({required this.data, super.key});
  final GameCodeBlockData data;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameCodeBlockState();
}

class GameCodeBlockState extends ConsumerState<GameCodeBlock>
    with TickerProviderStateMixin {
  late final BLUI blui;
  late final GameManagerState gameManagerState;
  Offset position = const Offset(100, 100);
  Offset startPosition = const Offset(100, 100);
  late AnimationController _controller;
  late Animation<Offset> _animation;
  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    blui = ref.read(bluiProvider);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {
        position = _animation.value;
      });
    });
    super.initState();
  }

  void _animateBackToStartPosition(Offset offset) {
    _animation =
        Tween<Offset>(begin: offset, end: startPosition).animate(_controller);
    _controller.forward(from: 0.0);
  }

  Widget buildBlockState(CodeBlockState state) {
    switch (state) {
      case CodeBlockState.unselected:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: blui.getBlockColor(widget.data.type),
          ),
          child: Center(child: BLText(widget.data.name ?? '')),
        );
      case CodeBlockState.faded:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: blui.getBlockColor(widget.data.type).withAlpha(150),
          ),
          child: Center(child: BLText(widget.data.name ?? '')),
        );

      case CodeBlockState.selected:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: blui.getBlockColor(widget.data.type),
          ),
          child: Center(
              child: Column(
            children: [
              BLText(widget.data.name ?? ''),
              DragTarget(
                builder: (context, accepted, rejected) {
                  return const SizedBox(width: 100, height: 100);
                },
                onAcceptWithDetails: (details) {},
                onWillAcceptWithDetails: (details) {
                  return true;
                },
                onMove: (details) {},
                onLeave: (details) {},
              )
            ],
          )),
        );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerStateProvider);
    // TODO: animate when cancelled
    return Draggable(
      data: '',
      onDragUpdate: (details) {},
      onDragStarted: () {
        gameManagerState.passBlock(widget.data);
        //startPosition = position;
      },
      onDraggableCanceled: (velocity, offset) {
        gameManagerState.removePassedBlock();
        gameManagerState.isDropCancelled(true);
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
}
