import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:block_logic/logic/services/should_reset_block.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class BlockSelectorStack extends ConsumerStatefulWidget {
  final GameBlockData data;
  const BlockSelectorStack(this.data, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSelectorStackState();
}

class _BlockSelectorStackState extends ConsumerState<BlockSelectorStack> {
  late int count;
  late final GameManager gameManager;
  Tuple2<CodeBlockType, String>? currentTuple;
  @override
  void initState() {
    count = widget.data.inSelectorCount!;
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  void updateStackCount({
    bool add = true,
  }) {
    if (add) {
      setState(() {
        count++;
      });
    } else {
      setState(() {
        count--;
      });
    }
  }

  void resetCount() {
    setState(() {
      count = widget.data.inSelectorCount!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shouldReset = ref.watch(shouldResetAllBlocksProvider);
    final shouldResetBlock = ref.watch(shouldResetBlockProvider(currentTuple));
    if (shouldReset) {
      resetCount();
      // no need to ref.invalidate because the GameBlock will do so.
    }
    if (shouldResetBlock) {
      updateStackCount(add: true);
    }
    return Visibility(
        visible: count > 0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...List.generate(count, (i) {
              return GameBlock(
                data: widget.data,
                updateStackCount: updateStackCount,
                resetCount: resetCount,
              );
            }),
            Positioned(
                top: -3,
                right: -3,
                child: Badge(
                  backgroundColor: Colors.white,
                  label: BLText(
                    count.toString(),
                    bold: true,
                    color: Colors.black,
                    size: 13,
                  ),
                ))
          ],
        ));
  }
}
