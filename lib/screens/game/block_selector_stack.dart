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
  Map<int, String> blockIDs = {};
  @override
  void initState() {
    count = widget.data.inSelectorCount!;
    debugPrint('Initial Count: $count');
    gameManager = ref.read(gameManagerProvider.notifier);
    blockIDs = {for (int i = 0; i < count; i++) i: ''};
    super.initState();
  }

  void updateStackCount({
    bool add = true,
  }) async {
    if (add) {
      if (count < widget.data.inSelectorCount!) {
        setState(() {
          count++;
        });
      }
    } else {
      if (count > 0) {
        setState(() {
          count--;
        });
      }
    }
  }

  void resetCount() {
    setState(() {
      count = widget.data.inSelectorCount!;
    });
  }

  void updateInSelectorUID(String uid, int index) {
    if (uid.isNotEmpty) {
      blockIDs.addAll({index: uid});
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldReset = ref.watch(shouldResetAllBlocksProvider);
    if (shouldReset) {
      debugPrint('should reset all from block stack');
      resetCount();
      // no need to ref.invalidate because the GameBlock will do so.
    }
    return Visibility(
        visible: count > 0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...List.generate(widget.data.inSelectorCount!, (i) {
              final Tuple2<CodeBlockType, String> blockID = Tuple2(widget.data.type, blockIDs[i]!);
              final shouldResetBlock = ref.watch(shouldResetBlockProvider(blockID));
              if (shouldResetBlock) {
                debugPrint('should reset block from block stack');
                updateStackCount(add: true);
              }
              return GameBlock(
                data: widget.data,
                updateStackCount: updateStackCount,
                updateInSelectorUID: updateInSelectorUID,
                resetCount: resetCount,
                stackIndex: i,
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
