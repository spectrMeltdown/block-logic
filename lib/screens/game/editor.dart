import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/screens/game/blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockDropOff extends ConsumerStatefulWidget {
  const BlockDropOff({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockDropOffState();
}

class _BlockDropOffState extends ConsumerState<BlockDropOff>
    with TickerProviderStateMixin {
  late TabController mainTabController;
  List<String> mainTabList = [];
  List<Widget> mainTabViewList = [];
  @override
  void initState() {
    mainTabList = ['Main'];
    mainTabViewList = [const CustomTabView()];
    mainTabController =
        TabController(length: mainTabList.length + 1, vsync: this);

    mainTabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void addNew() {
    /// add the new tab
    mainTabList.add('New ${mainTabList.length + 1}');
    mainTabViewList.add(const CustomTabView());

    mainTabController = TabController(
        length: mainTabList.length + 1,
        vsync: this,
        initialIndex: mainTabList.length - 1);
    setState(() {});
  }

  Widget buildTab(String tabName, int tabNum, int selectedIndex) {
    return CustomTab(
      tabNum == 0 ? 'Main' : tabName,
      isSelected: selectedIndex == tabNum,
    );
  }

  Widget buildTabView() {
    return const CustomTabView();
  }

  void disableForAddTab(int index) {
    /// if add tab was tapped, move back to previousIndex
    mainTabController.index = index == mainTabController.length
        ? mainTabController.previousIndex
        : index;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    mainTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = ref.watch(bLMediaQueryProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                    onTap: disableForAddTab,
                    indicator: const BoxDecoration(color: Colors.transparent),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: Colors.white,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                    controller: mainTabController,
                    tabs: [
                      ...List.generate(
                          mainTabList.length,
                          (index) => buildTab(mainTabList[index], index,
                              mainTabController.index)),
                      AddTab(addNew)
                    ]),
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.maxFinite,
          height: mediaQuery.screenH(context) / 2,
          child: BLBorderedPanel(
            TabBarView(
                clipBehavior: Clip.antiAlias,
                physics: const NeverScrollableScrollPhysics(),
                controller: mainTabController,
                children: [
                  ...List.generate(
                      mainTabViewList.length, (index) => buildTabView()),

                  /// placeholder since tabs & tabview length must match
                  /// (tabs has an extra tab for add tab)
                  const Placeholder()
                ]),
          ),
        )
      ],
    );
  }
}

class AddTab extends StatefulWidget {
  const AddTab(this.callback, {super.key});
  final VoidCallback callback;
  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  void onTapUp(TapUpDetails tap) {
    widget.callback.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTapUp: onTapUp, child: const CustomTab('+'));
  }
}

class CustomTabView extends ConsumerStatefulWidget {
  const CustomTabView({super.key});

  @override
  ConsumerState<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends ConsumerState<CustomTabView> {
  GameCodeBlockData? obtainedBlock;
  List<Widget> codeBlocks = [];
  bool addedPlaceholder = false;

  @override
  void initState() {
    super.initState();
  }

  void addBlock(GameCodeBlockData data) {
    removePlaceholder();
    final dataSelected = data.copyWith(state: CodeBlockState.selected);
    debugPrint('add block ${dataSelected.state}');
    codeBlocks.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: GameCodeBlock(data: dataSelected),
        )
      ],
    ));
    setState(() {});
  }

  void addPlaceholder(GameCodeBlockData data) {
    if (addedPlaceholder == true) return;
    final dataWithPlaceholder = data.copyWith(state: CodeBlockState.faded);
    debugPrint('add placeholder ${dataWithPlaceholder.state}');
    codeBlocks.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: GameCodeBlock(data: dataWithPlaceholder),
        )
      ],
    ));
    addedPlaceholder = true;
    setState(() {});
  }

  void removePlaceholder() {
    if (codeBlocks.isNotEmpty && addedPlaceholder == false) {
      codeBlocks.removeLast();
      debugPrint('removed placeholder - $codeBlocks');
      addedPlaceholder = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = ref.watch(gameManagerStateProvider);
    final gameManagerState = ref.read(gameManagerStateProvider.notifier);
    if (gameManager.isDropCancelled) {
      // TODO: if drop was cancelled, reverse to previous state of this widget
      gameManagerState.isDropCancelled(false);
      setState(() {});
    }
    return DragTarget(
      // rejected bypasses onMove
      builder: (context, accepted, rejected) {
        if (codeBlocks.isNotEmpty) {
          return ListView(
            children: codeBlocks,
          );
        }
        return const Center(child: BLText('Drop a block'));
      },
      onWillAcceptWithDetails: (details) {
        obtainedBlock = gameManagerState.obtainBlock();
        if (obtainedBlock == null) return false;
        return obtainedBlock?.state == CodeBlockState.unselected;
      },
      onAcceptWithDetails: (details) {
        if (obtainedBlock == null) return;
        addBlock(obtainedBlock!);
      },
      onMove: (details) {
        if (obtainedBlock == null) return;
        addPlaceholder(obtainedBlock!);
      },
      onLeave: (details) {
        removePlaceholder();
      },
    );
  }
}

class CustomTab extends ConsumerWidget {
  const CustomTab(this.text,
      {this.isSelected = false,
      this.textColor,
      this.isBold = false,
      super.key});
  final String text;
  final Color? textColor;
  final bool isBold;
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BLText(
          text,
          color: textColor ?? Colors.black,
          bold: isSelected,
        ),
      ),
    );
  }
}
