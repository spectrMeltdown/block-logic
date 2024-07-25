import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBlocks extends ConsumerStatefulWidget {
  const GameBlocks({super.key});

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
  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
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

  Widget buildBlockTabs(String title, int tabNum, int selectedIndex) {
    return BlocksTab(title, isSelected: tabNum == selectedIndex);
  }

  Widget buildBlockView() {
    // TODO: get List<Challenge> from challenge data
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SpacedRow(
        spacing: 10,
        children: [
          GameCodeBlock(
            data: GameCodeBlockData(
                type: CodeBlockType.classes,
                name: 'class1',
                state: CodeBlockState.unselected),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = ref.watch(bLMediaQueryProvider);
    ref.watch(gameManagerStateProvider);
    return Flexible(
      flex: 0,
      child: Column(
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
                        indicator:
                            const BoxDecoration(color: Colors.transparent),
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: Colors.white,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                        indicatorColor: BLUI().getAppColor(''),
                        controller: blocksTabController,
                        tabs: [
                          ...List.generate(
                              blocksTabList.length,
                              (index) => buildBlockTabs(blocksTabList[index],
                                  index, blocksTabController.index))
                        ]),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: mediaQuery.screenH(context) / 10,
            child: BLBorderedPanel(
              TabBarView(
                  clipBehavior: Clip.antiAlias,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: blocksTabController,
                  children: [
                    ...List.generate(
                        blocksTabList.length, (index) => buildBlockView())
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

class BlocksTab extends ConsumerWidget {
  const BlocksTab(this.text, {this.isSelected = false, super.key});
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tab(
      height: 25,
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: BLText(
          text,
          color: Colors.black,
          bold: isSelected,
        ),
      ),
    );
  }
}
