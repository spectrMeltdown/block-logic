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
  final void Function(String, int)? updateInSelectorUID;
  final void Function()? resetCount;
  final int? stackIndex;
  const GameBlock({required this.data, this.updateStackCount, this.stackIndex, this.updateInSelectorUID, this.resetCount, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameCodeBlockState();
}

class GameCodeBlockState extends ConsumerState<GameBlock> with TickerProviderStateMixin {
  late final GameManager gameManager;
  late final BLUI blui;
  bool shouldResetSelf = false;
  late Widget block;
  late Widget defaultWithPadding;
  GameBlockData? finalData;

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    blui = ref.read(bLUIProvider.notifier);

    defaultWithPadding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: BlockRender(widget.data),
    );
    if (widget.data.state == CodeBlockState.inSelector) {
      // debugPrint('Built as inSelector');
      block = defaultWithPadding;
      final uid = gameManager.getUID();
      finalData = widget.data.copyWith(inSelectorUID: uid);
      gameManager.addInSelectorUIDs(finalData!.type, finalData!.inSelectorUID!);
      if (widget.updateInSelectorUID != null && widget.stackIndex != null) {
        widget.updateInSelectorUID!(uid, widget.stackIndex!);
      }
    } else {
      block = BlockRender(widget.data);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        // if (widget.updateStackCount != null) {
        //   // widget.resetCount!();
        //   widget.updateStackCount!(add: true);
        // }
        gameManager.addInSelectorUIDs(finalData!.type, finalData!.inSelectorUID!);
        gameManager.incrementCategory(widget.data.type);
        ref.invalidate(customTabProvider);
        ref.invalidate(shouldResetBlockProvider);
      }
    }

    if (widget.data.state == CodeBlockState.inSelector) {
      return Draggable<GameBlockData>(
          hitTestBehavior: HitTestBehavior.opaque,
          // delay: const Duration(milliseconds: 100),
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
          },
          onDraggableCanceled: (velocity, offset) {},
          onDragEnd: (details) {
            if (widget.data.state == CodeBlockState.inEditor) {
              gameManager.toggleReturnBlock(false);
              ref.invalidate(returnBlockProvider);
            }
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
          child: block);
    }
    return LongPressDraggable<GameBlockData>(
        hitTestBehavior: HitTestBehavior.opaque,
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
        },
        onDragEnd: (details) {
          if (widget.data.state == CodeBlockState.inEditor) {
            gameManager.toggleReturnBlock(false);
            ref.invalidate(returnBlockProvider);
          }
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
        child: block);
  }
}
