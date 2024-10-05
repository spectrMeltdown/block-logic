import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
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
  final scrollController = ScrollController();
  // bool isScrollbarVisible = false;
  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    // checkScrollbarVisibility();
    // scrollController.addListener();
    super.initState();
  }

  // void checkScrollbarVisibility() {
  //   // Check if the scroll extent is greater than 0, which indicates content is scrollable
  //   if (scrollController.position.maxScrollExtent > 0) {
  //     setState(() {
  //       isScrollbarVisible = true;
  //     });
  //   } else {
  //     setState(() {
  //       isScrollbarVisible = false;
  //     });
  //   }
  // }

  @override
  void dispose() {
    // scrollController.removeListener(checkScrollbarVisibility);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // TODO: MUST KEEP BECAUSE ADDING/REMOVING BLOCKS WONT WORK WIHTOUT IT
    // shouldReset = ref.watch(shouldResetBlockProvider);
    // if (shouldReset!) {
    //   gameManager.setshouldRedisplay(false);
    //   ref.invalidate(shouldRedisplayProvider);
    // }
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
              // spacing: 10,
              children: List.generate(widget.blockData.length, (i) {
                final data = widget.blockData[i];
                final count = data.inSelectorCount;
                if (count != null) {
                  debugPrint('Count from selector view: $count');
                  return BlockSelectorStack(data);
                }
                return GameBlock(data: data);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
