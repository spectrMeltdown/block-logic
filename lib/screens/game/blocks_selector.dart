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
  Map<CodeBlockType, int> countPerCategory = {};
  // bool firstBuild = true;
  // late List<String> topBlocksList;
  // late List<String> bottomBlocksList;
  late Map<CodeBlockType, List<GameBlockData>> blocks;
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
                      tabs: List.generate(blocks.keys.length, (i) {
                        return Consumer(builder: (context, ref, child) {
                          final type = blocks.keys.toList()[i];
                          // final count = ref.watch(CustomTabProvider(type));
                          final count = ref.watch(customTabProvider(type));
                          return CustomTab(
                            type: type,
                            count: count,
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
                blocks.keys.length,
                (index) {
                  return BlockSelectorView(blockData: widget.blocks[blocks.keys.toList()[index]]!);
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
    final gameManagerState = ref.read(gameManagerProvider);
    // topBlocksList = blocksTabList.where((a) => a == 'Variables' || a == 'Literals' || a == 'Keywords').toList();
    blocks = widget.blocks;

    // blocksTabList.remove('FunctionDefinition');
    for (final entry in blocks.entries) {
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
      gameManagerState.categoryCount[entry.key] = entry.value;
    }
    blocksTabController = TabController(length: blocks.keys.length, vsync: this);
    blocksTabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }
}
