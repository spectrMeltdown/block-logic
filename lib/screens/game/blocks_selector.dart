import 'package:block_logic/components/panel.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/blocks_selector_view.dart';
import 'package:block_logic/screens/game/custom_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlocks extends ConsumerStatefulWidget {
  const GameBlocks(this.blocks, {super.key});
  final Map<CodeBlockType, List<GameBlockData>> blocks;

  @override
  ConsumerState<GameBlocks> createState() => _GameBlocksState();
}

class _GameBlocksState extends ConsumerState<GameBlocks>
    with TickerProviderStateMixin {
  late TabController blocksTabController;
  late GameManagerState gameManagerState;
  List<String> blocksTabList =
      List.generate(CodeBlockType.values.length, (index) {
    final name = CodeBlockType.values[index].name;
    final firstLetter = name[0].toUpperCase();
    return firstLetter + name.substring(1, name.length);
  });
  late Map<CodeBlockType, List<GameBlockData>> blocks;
  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    // TODO: get Map<CodeBlockType[], List<GameBlockData>> from challenge data
    blocks = AllBlocks.getAllBlocks();
    blocksTabList.remove('FunctionDefinition');
    blocksTabController =
        TabController(length: blocksTabList.length, vsync: this);
    blocksTabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    blocksTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = ref.watch(bLMediaQueryProvider);
    ref.watch(gameManagerStateProvider);
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
          height: mediaQuery.screenH(context) / 11,
          child: BLBorderedPanel(
            TabBarView(
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
}
