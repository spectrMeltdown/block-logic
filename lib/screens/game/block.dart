import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game/tab_num_provider.dart';
import 'package:block_logic/logic/services/game/game_manager.dart';
import 'package:block_logic/logic/services/game/return_block.dart';
import 'package:block_logic/logic/services/game/should_reset_all_blocks.dart';
import 'package:block_logic/logic/services/game/should_reset_block.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block_render.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class GameBlock extends ConsumerStatefulWidget {
  final GameBlockData data;
  final void Function({bool add})? updateStackCount;
  // final void Function(int, String)? updateInSelectorUID;
  final void Function()? resetCount;
  final int? stackIndex;
  final String? challengeUID;
  final bool topLevelBlock;
  const GameBlock({
    this.challengeUID,
    this.topLevelBlock = false,
    required this.data,
    this.updateStackCount,
    this.stackIndex,
    // this.updateInSelectorUID,
    this.resetCount,
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => GameCodeBlockState();
}

class GameCodeBlockState extends ConsumerState<GameBlock> {
  late final GameManager gameManager;
  late final BLUI blui;
  late Widget block;
  late Widget defaultWithPadding;
  String? previousChallengeUID;

  @override
  void initState() {
    super.initState();
    // debugPrint('Init block: ${widget.data.name}');
    gameManager = ref.read(gameManagerProvider.notifier);
    blui = ref.read(bLUIProvider.notifier);
    create();
  }

  void create() {
    previousChallengeUID = widget.challengeUID;
    defaultWithPadding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: BlockRender(widget.data),
    );
    if (widget.data.state == CodeBlockState.inSelector) {
      block = defaultWithPadding;
    } else {
      block = BlockRender(widget.data);
    }
  }

  void onDragCompleted() {
    if (widget.data.state == CodeBlockState.inSelector) {
      // debugPrint('decrement count');
      if (widget.updateStackCount != null) {
        widget.updateStackCount!(add: false);
      }
      // debugPrint('Decrement ${widget.data.type}');
      gameManager.decrementCategory(widget.data.type);
      ref.invalidate(tabNumberProvider);
      setState(() {
        block = const BlankWidget();
      });
    }
  }

  void onDragEnd(details) {
    if (widget.data.state == CodeBlockState.inEditor) {
      gameManager.toggleReturnBlock(false);
      ref.invalidate(returnBlockProvider);
    }
  }

  void onDragStarted() {
    if (widget.data.state == CodeBlockState.inEditor) {
      gameManager.toggleReturnBlock(true);
      ref.invalidate(returnBlockProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // debugPrint('Previous challenge uid was $previousChallengeUID');
    // debugPrint('Current challenge uid was ${widget.challengeUID}');
    if (widget.data.type == CodeBlockType.statement) {
      debugPrint('from block ${widget.data.uid}');
      debugPrint('from block ${widget.data.statementUIDs}\n');
    }
    // trigger rebuilds when the challenge has changed
    if (widget.topLevelBlock && previousChallengeUID != widget.challengeUID) {
      create();
      // debugPrint('rebuild block triggered');
      setState(() {});
    }
    // debugPrint('BLOCK REBUILT');
    // debugPrint(widget.data.toJSON().toString());
    final shouldResetFromAll = ref.watch(shouldResetAllBlocksProvider);

    if (widget.data.state == CodeBlockState.inSelector) {
      if (shouldResetFromAll) {
        // debugPrint('shouldResetFromAll');
        setState(() {
          block = defaultWithPadding;
        });
        // reset all tabs counts to 0
        gameManager.resetAllCategory();
        // switch reset all block to false (future.delayed to prevent race condition)
        Future.delayed(Duration.zero, () {
          gameManager.setShouldResetAllBlocks(false);
          ref.invalidate(shouldResetAllBlocksProvider);
        });
      }

      final shouldResetBlock = ref.watch(shouldResetBlockProvider(Tuple2(widget.data.type, widget.data.inSelectorUID!)));
      // redisplay block if requested
      if (shouldResetBlock) {
        // debugPrint('shouldResetSelf');
        // if (widget.updateStackCount != null) {
        //   debugPrint('increment count');
        //   widget.updateStackCount!(add: true);
        // }
        gameManager.addInSelectorUIDs(widget.data.type, widget.data.inSelectorUID!);
        gameManager.incrementCategory(widget.data.type);
        ref.invalidate(shouldResetBlockProvider);
        ref.invalidate(tabNumberProvider);
        setState(() {
          block = defaultWithPadding;
        });
        // Future.delayed(Duration.zero, () {});
      }

      // draggable in selector
      return Draggable<GameBlockData>(
          hitTestBehavior: HitTestBehavior.opaque,
          data: widget.data, // drag target will not detect if data is null
          dragAnchorStrategy: (draggable, context, position) {
            // make feedback block appear on the right top corner
            return const Offset(-30, 50);
          },
          onDragCompleted: onDragCompleted,
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
        delay: const Duration(milliseconds: 200),
        data: widget.data, // drag target will not detect if data is null
        onDragUpdate: (details) {},
        dragAnchorStrategy: (draggable, context, position) {
          return const Offset(-30, 50);
        },
        onDragStarted: onDragStarted,
        onDragEnd: onDragEnd,
        childWhenDragging: AnimatedOpacity(
          opacity: 0.3,
          duration: Duration.zero,
          child: block,
        ),
        feedback: Transform.scale(scale: 0.8, child: block), // the widget that follws the touch position
        child: block);
  }
}
