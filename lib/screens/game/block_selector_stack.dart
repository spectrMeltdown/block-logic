import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/should_reset_all_blocks.dart';
import 'package:block_logic/logic/game/logic/should_reset_block.dart';
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
  //   @override
  // bool get wantKeepAlive => true;

  late int count;
  late final GameManager gameManager;
  List<String> blockIDs = [];
  int lastHashCode = 0;

  @override
  void initState() {
    super.initState();
    gameManager = ref.read(gameManagerProvider.notifier);
    createStackCount();
  }

  void createStackCount() {
    // debugPrint('Initial Count: $count');
    final gameState = ref.read(gameManagerProvider);
    setState(() {
      count = widget.data.inSelectorCount!;
      // generate map of ids based on inSelectorCount
      blockIDs = List.generate(count, (i) => '${widget.data.inSelectorUID}$i');
    });
    final Map<CodeBlockType, List<String>> insUIDs = Map.from(gameState.inSelectorUIDs);
    final dataInsUID = widget.data.inSelectorUID;
    for (final list in insUIDs.values) {
      if (list.contains(dataInsUID)) {
        final index = list.indexWhere((i) => i == dataInsUID);
        list.removeAt(index);
        list.insertAll(index, blockIDs);
      }
    }
    gameState.inSelectorUIDs = insUIDs;
  }

  Future<void> updateStackCount({
    bool add = true,
  }) async {
    // debugPrint('Updating Count: $count');
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

  // void updateInSelectorUID(int index, String uid) {
  //   if (uid.isNotEmpty) {
  //     Future.delayed(Duration.zero, () {
  //       setState(() {
  //         blockIDs[index] = uid;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // create stack count when data changes (e.g. changing the challenge)
    final shouldReset = ref.watch(shouldResetAllBlocksProvider);
    // reset the entire stack
    if (shouldReset) {
      // debugPrint('should reset all from block stack');
      resetCount();
    }
    // debugPrint(ref.read(gameManagerProvider).inSelectorUIDs.toString());
    return Visibility(
        visible: count > 0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // generate stack based on inSelectorCount
            ...List.generate(widget.data.inSelectorCount!, (i) {
              // get id from blockIDs (will be empty string at first, updated later by the child block)
              final shouldResetBlock = ref.watch(shouldResetBlockProvider(Tuple2(widget.data.type, blockIDs[i])));
              // when resetting an individual block from this stack (e.g. returning the block to selector)
              if (shouldResetBlock) {
                // debugPrint('should reset block from block stack');
                updateStackCount(add: true);
              }
              // debugPrint(blockIDs[i].toString());
              return GameBlock(
                key: ValueKey(blockIDs[i]),
                data: widget.data.copyWith(inSelectorUID: blockIDs[i]),
                updateStackCount: updateStackCount,
                // updateInSelectorUID: updateInSelectorUID,
                resetCount: resetCount,
                // stackIndex: i,
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
