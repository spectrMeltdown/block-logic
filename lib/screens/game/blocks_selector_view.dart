import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/block_selector_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorView extends ConsumerStatefulWidget {
  const BlockSelectorView({required this.challengeUID, required this.blockData, super.key});
  final List<GameBlockData> blockData;
  final String challengeUID;
  @override
  ConsumerState<BlockSelectorView> createState() => _BlockSelectorViewState();
}

class _BlockSelectorViewState extends ConsumerState<BlockSelectorView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final GameManager gameManager;
  final scrollController = ScrollController();
  List<GameBlockData> blockData = [];

  @override
  void initState() {
    super.initState();
    gameManager = ref.read(gameManagerProvider.notifier);
    blockData = widget.blockData;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BlockSelectorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.challengeUID != oldWidget.challengeUID) {
      debugPrint('rebuild selector');
      setState(() {
        blockData = widget.blockData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      interactive: true,
      thickness: 10,
      radius: const Radius.circular(10),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 15),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: List.generate(blockData.length, (i) {
                if (blockData[i].inSelectorCount != null) {
                  // debugPrint('Count from selector view: ${widget.blockData[i].inSelectorCount}');
                  return BlockSelectorStack(blockData[i]);
                }
                return GameBlock(
                  data: blockData[i],
                  topLevelBlock: true,
                  challengeUID: widget.challengeUID,
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
