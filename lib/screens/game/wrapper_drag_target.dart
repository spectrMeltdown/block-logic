import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DragTargetWrapper extends ConsumerStatefulWidget {
  final Function()? builder;
  final bool Function(GameBlockData) onWillAcceptWithDetails;
  final void Function(GameBlockData, GameManager)? onAcceptWithDetails;
  final Widget Function()? builderChild;
  final void Function()? onLeave;
  const DragTargetWrapper({
    required this.builderChild,
    required this.onWillAcceptWithDetails,
    this.onAcceptWithDetails,
    this.onLeave,
    this.builder,
    super.key,
  });

  @override
  ConsumerState<DragTargetWrapper> createState() => _GameDragTargetState();
}

class _GameDragTargetState extends ConsumerState<DragTargetWrapper> {
  // GameBlockData? blockData;
  bool editorOutline = false;
  late final GameManager gameManager;
  final outlineDecor = BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.white));
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: editorOutline ? outlineDecor : null,
      child: DragTarget<GameBlockData>(
        builder: (context, accepted, rejected) {
          widget.builder?.call();
          return widget.builderChild?.call() ?? const SizedBox(width: 80, height: 40);
        },
        onAcceptWithDetails: (details) {
          setState(() {
            editorOutline = false;
          });
          // if (blockData == null) return;
          widget.onAcceptWithDetails?.call(details.data, gameManager);
        },
        onWillAcceptWithDetails: (details) {
          // blockData = gameManager.obtainPassedBlockData();
          // if (details.data == null) return false;
          final shouldAccept = widget.onWillAcceptWithDetails.call(details.data);
          if (shouldAccept) {
            setState(() {
              editorOutline = true;
            });
          }
          return shouldAccept;
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

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
