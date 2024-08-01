import 'package:block_logic/components/panel.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/screens/game/custom_add_tab.dart';
import 'package:block_logic/screens/game/custom_tab.dart';
import 'package:block_logic/screens/game/editor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Editor extends ConsumerStatefulWidget {
  const Editor({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditorState();
}

class _EditorState extends ConsumerState<Editor> with TickerProviderStateMixin {
  late TabController mainTabController;
  List<String> mainTabList = [];
  List<Widget> mainTabViewList = [];
  final editorWidgetKey = GlobalKey();
  @override
  void initState() {
    mainTabList = ['Main'];
    mainTabViewList = [EditorView(editorWidgetKey: editorWidgetKey)];
    mainTabController =
        TabController(length: mainTabList.length + 1, vsync: this);

    mainTabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Widget buildTab(String tabName, int tabNum, int selectedIndex) {
    return CustomTab(
      title: tabNum == 0 ? 'Main' : tabName,
      isSelected: selectedIndex == tabNum,
    );
  }

  Widget buildTabView() {
    return EditorView(
      editorWidgetKey: editorWidgetKey,
    );
  }

  void addNew() {
    /// add the new tab
    mainTabList.add('New ${mainTabList.length + 1}');
    mainTabViewList.add(EditorView(editorWidgetKey: editorWidgetKey));

    mainTabController = TabController(
        length: mainTabList.length + 1,
        vsync: this,
        initialIndex: mainTabList.length - 1);
    setState(() {});
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
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                        onTap: disableForAddTab,
                        indicator:
                            const BoxDecoration(color: Colors.transparent),
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
          ),
          SizedBox(
            key: editorWidgetKey,
            width: double.maxFinite,
            height: mediaQuery.screenH(context) / 1.95,
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
      ),
    );
  }
}
