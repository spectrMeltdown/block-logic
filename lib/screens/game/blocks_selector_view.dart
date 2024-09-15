import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/should_reset_all_blocks.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/block_selector_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorView extends ConsumerStatefulWidget {
  const BlockSelectorView({required this.blockData, super.key});
  final List<GameBlockData> blockData;
  @override
  ConsumerState<BlockSelectorView> createState() => _BlockSelectorViewState();
}

class _BlockSelectorViewState extends ConsumerState<BlockSelectorView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? shouldReset;
  late final GameManager gameManager;

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // shouldReset = ref.watch(shouldResetBlockProvider);
    // if (shouldReset!) {
    //   gameManager.setshouldRedisplay(false);
    //   ref.invalidate(shouldRedisplayProvider);
    // }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Row(
          // spacing: 10,
          children: List.generate(widget.blockData.length, (i) {
            final data = widget.blockData[i];
            final count = data.inSelectorCount;
            if (count != null) {
              return BlockSelectorStack(data);
            }
            return GameBlock(data: data);
          }),
        ),
      ),
    );
  }
}
