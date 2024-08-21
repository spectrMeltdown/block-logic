import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/screens/game/block.dart';
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

class _GameBlocksState extends ConsumerState<GameBlocks>
    with TickerProviderStateMixin {
  late TabController blocksTabController;
  late GameManager gameManager;
  List<String> blocksTabList =
      List.generate(CodeBlockType.values.length, (index) {
    final name = CodeBlockType.values[index].name;
    final firstLetter = name[0].toUpperCase();
    return firstLetter + name.substring(1, name.length);
  });
  late Map<CodeBlockType, List<GameBlockData>> blocks;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    ref.watch(gameManagerProvider);
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
                      tabs: List.generate(
                          blocksTabList.length,
                          (index) => CustomTab(
                                title: blocksTabList[index],
                                isSelected: index == blocksTabController.index,
                                paddingX: 10,
                              ))),
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
                    blocksTabList.length,
                    (index) => BlockSelectorView(
                            blocks: widget.blocks[CodeBlockType.values[index]]!
                                .map((data) {
                          return GameBlock(data: data);
                        }).toList()))),
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
    // TODO: get Map<CodeBlockType[], List<GameBlockData>> from challenge data
    blocks = AllBlocks.get();
    blocksTabList.remove('FunctionDefinition');
    blocksTabController =
        TabController(length: blocksTabList.length, vsync: this);
    blocksTabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }
}
