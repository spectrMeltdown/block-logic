import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/tab_num_provider.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/blocks_selector_view.dart';
import 'package:block_logic/screens/game/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlocks extends ConsumerStatefulWidget {
  final Map<CodeBlockType, List<GameBlockData>> blocks;
  final String challengeUID;
  const GameBlocks(this.blocks, this.challengeUID, {super.key});

  @override
  ConsumerState<GameBlocks> createState() => _GameBlocksState();
}

class _GameBlocksState extends ConsumerState<GameBlocks> with TickerProviderStateMixin {
  late TabController blocksTabController;
  late GameManager gameManager;
  String currentUID = '';
  Map<CodeBlockType, List<GameBlockData>> blocks = {};

  @override
  void initState() {
    super.initState();
    gameManager = ref.read(gameManagerProvider.notifier);
    // buildSelector();
  }

  bool newBuild() {
    if (currentUID != widget.challengeUID) {
      currentUID = widget.challengeUID;
      return true;
    } else {
      return false;
    }
  }

  void buildSelector() {
    dPrint('block selector called');
    // dPrint(blocks.values.length.toString());
    final gameState = ref.read(gameManagerProvider);

    // update the blocks inselector uids
    Map<CodeBlockType, List<GameBlockData>> newBlocks = {};
    for (final categoryList in widget.blocks.values) {
      for (final data in categoryList) {
        // create an inselector uid
        final uid = gameManager.getUID();
        // assign the uid (only when this is a new block)
        final finalData = data.copyWith(inSelectorUID: uid);
        // add to inSelectorUIDs
        gameManager.addInSelectorUIDs(finalData.type, finalData.inSelectorUID!);

        // add the new datas to the temp new blocks
        if (newBlocks[finalData.type] != null) {
          newBlocks[finalData.type]!.add(finalData);
        } else {
          newBlocks.addAll({
            finalData.type: [finalData]
          });
        }
      }
    }
    // replace blocks with new blocks
    blocks = Map.from(newBlocks);

    // update the tab controller
    setState(() {
      blocksTabController = TabController(length: blocks.keys.length, vsync: this);
      blocksTabController.addListener(() {
        setState(() {});
      });
    });
    // update the counts per tab
    Map<CodeBlockType, int> countsPerTab = {};
    for (final entry in blocks.entries) {
      int count = 0;
      for (final block in entry.value) {
        if (block.inSelectorCount == null) {
          count++;
        } else {
          count += block.inSelectorCount!;
        }
      }
      countsPerTab[entry.key] = count;
    }

    // update the counts per tab
    for (final entry in countsPerTab.entries) {
      gameState.countsPerTab[entry.key] = CountPerTab(maxCount: entry.value, currentCount: entry.value);
    }

    Future.delayed(Duration.zero, () {
      ref.invalidate(tabNumberProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final shouldReset = ref.watch(shouldResetAllBlocksProvider);
    // if (shouldReset) {

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
                      tabs: List.generate(blocks.keys.length, (i) {
                        return CustomTab(
                          type: blocks.keys.toList()[i],
                          isSelected: i == blocksTabController.index,
                          paddingX: 10,
                        );
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
                  return BlockSelectorView(
                    blockData: blocks[blocks.keys.toList()[index]] ?? [],
                    type: blocks.keys.toList()[index],
                    challengeUID: widget.challengeUID,
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
}
