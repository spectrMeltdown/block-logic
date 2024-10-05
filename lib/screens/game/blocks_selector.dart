import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/custom_tab.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/blocks_selector_view.dart';
import 'package:block_logic/screens/game/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlocks extends ConsumerStatefulWidget {
  final Map<CodeBlockType, List<GameBlockData>> blocks;
  const GameBlocks(this.blocks, {super.key});

  @override
  ConsumerState<GameBlocks> createState() => _GameBlocksState();
}

class _GameBlocksState extends ConsumerState<GameBlocks> with TickerProviderStateMixin {
  late TabController blocksTabController;
  late GameManager gameManager;
  int? previousBlockCount;
  // bool firstBuild = true;
  // late List<String> topBlocksList;
  // late List<String> bottomBlocksList;

  bool newBuild() {
    int currentBlockCount = 0;
    for (int i = 0; i < widget.blocks.values.length; i++) {
      for (final data in widget.blocks.values.toList()[i]) {
        if (data.inSelectorCount != null) {
          currentBlockCount += data.inSelectorCount!;
        } else {
          currentBlockCount++;
        }
      }
    }
    if (previousBlockCount == null || previousBlockCount != currentBlockCount) {
      debugPrint('Previous count: $previousBlockCount');
      debugPrint('Current count: $currentBlockCount');
      previousBlockCount = currentBlockCount;
      return true;
    } else {
      return false;
    }
  }

  void buildSelector() {
    debugPrint('Build selector called');
    debugPrint(widget.blocks.values.length.toString());
    final gameState = ref.read(gameManagerProvider);
    setState(() {
      blocksTabController = TabController(length: widget.blocks.keys.length, vsync: this);
      blocksTabController.addListener(() {
        setState(() {});
      });
    });
    Map<CodeBlockType, int> countPerCategory = {};
    for (final entry in widget.blocks.entries) {
      int count = 0;
      for (final block in entry.value) {
        if (block.inSelectorCount == null) {
          count++;
        } else {
          count += block.inSelectorCount!;
        }
      }
      countPerCategory[entry.key] = count;
    }
    for (final entry in countPerCategory.entries) {
      gameState.categoryCount[entry.key] = entry.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // if (firstBuild) {
    //   WidgetsBinding.instance.addPostFrameCallback((duration) {
    //     setState(() {
    //       firstBuild = false;
    //     });
    //   });
    // }
    if (newBuild()) buildSelector();
    // buildSelector();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TabBar(
                      indicator: const BoxDecoration(color: Colors.transparent),
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: Colors.white,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                      indicatorColor: BLUI().getAppColor(''),
                      controller: blocksTabController,
                      tabs: List.generate(widget.blocks.keys.length, (i) {
                        return Consumer(builder: (context, ref, child) {
                          final type = widget.blocks.keys.toList()[i];
                          final count = ref.watch(customTabProvider(type));
                          debugPrint('Count from customTabProvider: $count');
                          return CustomTab(
                            type: type,
                            count: count < 0 ? 0 : count,
                            isSelected: i == blocksTabController.index,
                            paddingX: 10,
                          );
                        });
                      })),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          height: mediaQuery.size.height / 11,
          child: BLBorderedPanel(
            child: TabBarView(
              clipBehavior: Clip.antiAlias,
              physics: const NeverScrollableScrollPhysics(),
              controller: blocksTabController,
              children: List.generate(
                widget.blocks.keys.length,
                (index) {
                  return BlockSelectorView(
                    blockData: widget.blocks[widget.blocks.keys.toList()[index]] ?? [],
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    blocksTabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    buildSelector();
    super.initState();
  }
}
