import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DragTargetWrapper extends ConsumerStatefulWidget {
  const DragTargetWrapper({
    required this.builderChild,
    required this.onWillAcceptWithDetails,
    this.onAcceptWithDetails,
    this.onLeave,
    this.builder,
    super.key,
  });
  final Function()? builder;
  final bool Function(GameBlockData?) onWillAcceptWithDetails;
  final void Function(GameBlockData?, GameManagerState)? onAcceptWithDetails;
  final Widget Function()? builderChild;
  final void Function()? onLeave;

  @override
  ConsumerState<DragTargetWrapper> createState() => _GameDragTargetState();
}

class _GameDragTargetState extends ConsumerState<DragTargetWrapper> {
  GameBlockData? blockData;
  bool editorOutline = false;
  late final GameManagerState gameManagerState;

  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: editorOutline
          ? BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white))
          : null,
      child: DragTarget(
        builder: (context, accepted, rejected) {
          widget.builder?.call();
          return widget.builderChild?.call() ??
              const SizedBox(width: 80, height: 40);
        },
        onAcceptWithDetails: (details) {
          setState(() {
            editorOutline = false;
          });
          widget.onAcceptWithDetails?.call(blockData!, gameManagerState);
        },
        onWillAcceptWithDetails: (details) {
          setState(() {
            editorOutline = true;
          });
          blockData = gameManagerState.obtainPassedBlockData();
          if (blockData == null) return false;
          return widget.onWillAcceptWithDetails.call(blockData);
        },
        onLeave: (details) {
          setState(() {
            editorOutline = false;
          });
          widget.onLeave?.call();
        },
      ),
    );
  }
}
