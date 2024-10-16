import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/challenge_manager.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/screens/challenges/add_custom_block.dart';
import 'package:block_logic/web/screens/challenges/block_selector_add_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabCount {
  int variables;
  int functions;
  int objects;
  int operators;
  int keywords;
  int literals;
  int conditionals;
  int loops;

  TabCount({
    this.variables = 0,
    this.functions = 0,
    this.objects = 0,
    this.operators = 0,
    this.keywords = 0,
    this.literals = 0,
    this.conditionals = 0,
    this.loops = 0,
  });
}

class TabCountManager extends StateNotifier<TabCount> {
  TabCountManager() : super(TabCount());
  void assign(CodeBlockType type, int count) {
    switch (type) {
      case CodeBlockType.variables:
        state.variables = count;
        break;
      case CodeBlockType.functions:
        state.functions = count;
        break;
      case CodeBlockType.objects:
        state.objects = count;
        break;
      case CodeBlockType.operators:
        state.operators = count;
        break;
      case CodeBlockType.keywords:
        state.keywords = count;
        break;
      case CodeBlockType.literals:
        state.literals = count;
        break;
      case CodeBlockType.conditionals:
        state.conditionals = count;
        break;
      case CodeBlockType.loops:
        state.loops = count;
        break;
      case CodeBlockType.statement:
        break;
    }
  }

  void increment(CodeBlockType type) {
    switch (type) {
      case CodeBlockType.variables:
        state.variables++;
        break;
      case CodeBlockType.functions:
        state.functions++;
        break;
      case CodeBlockType.objects:
        state.objects++;
        break;
      case CodeBlockType.operators:
        state.operators++;
        break;
      case CodeBlockType.keywords:
        state.keywords++;
        break;
      case CodeBlockType.literals:
        state.literals++;
        break;
      case CodeBlockType.conditionals:
        state.conditionals++;
        break;
      case CodeBlockType.loops:
        state.loops++;
        break;
      case CodeBlockType.statement:
        break;
    }
  }

  void decrement(CodeBlockType type) {
    switch (type) {
      case CodeBlockType.variables:
        state.variables--;
        break;
      case CodeBlockType.functions:
        state.functions--;
        break;
      case CodeBlockType.objects:
        state.objects--;
        break;
      case CodeBlockType.operators:
        state.operators--;
        break;
      case CodeBlockType.keywords:
        state.keywords--;
        break;
      case CodeBlockType.literals:
        state.literals--;
        break;
      case CodeBlockType.conditionals:
        state.conditionals--;
        break;
      case CodeBlockType.loops:
        state.loops--;
        break;
      case CodeBlockType.statement:
        break;
    }
  }
}

final tabCountProvider = StateNotifierProvider.autoDispose<TabCountManager, TabCount>((ref) {
  return TabCountManager();
});

class BlockSelectorDialog extends ConsumerStatefulWidget {
  final Map<CodeBlockType, List<GameBlockData>> initialBlocks;
  const BlockSelectorDialog({this.initialBlocks = const {}, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSelectorDialogState();
}

class _BlockSelectorDialogState extends ConsumerState<BlockSelectorDialog> with SingleTickerProviderStateMixin {
  late final Map<CodeBlockType, List<GameBlockData>> selectedBlocks;
  late final List<Tab> tabs;
  late TabController tabController;
  late final DialogService dialog;
  late final CustomNavigation nav;
  late final TabCountManager counter;
  late final ChallengeManager chManager;
  late final Toast toast;
  bool firstBuild = true;

  @override
  void initState() {
    dialog = ref.read(dialogServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    chManager = ref.read(challengeManagerProvider.notifier);
    counter = ref.read(tabCountProvider.notifier);
    selectedBlocks = {for (final type in CodeBlockType.values.where((e) => e != CodeBlockType.statement)) type: []};
    if (widget.initialBlocks.isNotEmpty) {
      for (final entry in widget.initialBlocks.entries) {
        selectedBlocks[entry.key] = entry.value;
        counter.assign(entry.key, selectedBlocks[entry.key]!.length);
      }
    }
    tabController = TabController(vsync: this, length: selectedBlocks.keys.length);
    super.initState();
  }

  void addCustom(CodeBlockType type) async {
    final result = await dialog.show(context, barrierDismissable: false, CustomBlockDialog(type));
    if (result is GameBlockData) {
      if (!mounted) return;
      nav.pop(context, result);
    } else {
      if (!mounted) return;
      toast.showToast(context, 'No block added.', type: NotifType.info);
    }
  }

  void buildTabs() {
    tabs = List.generate(selectedBlocks.keys.length, (i) {
      late int count;
      final type = CodeBlockType.values[i];
      switch (type) {
        case CodeBlockType.variables:
          count = ref.watch(tabCountProvider.select((s) => s.variables));
          break;
        case CodeBlockType.functions:
          count = ref.watch(tabCountProvider.select((s) => s.functions));
          break;
        case CodeBlockType.objects:
          count = ref.watch(tabCountProvider.select((s) => s.objects));
          break;
        case CodeBlockType.operators:
          count = ref.watch(tabCountProvider.select((s) => s.operators));
          break;
        case CodeBlockType.keywords:
          count = ref.watch(tabCountProvider.select((s) => s.keywords));
          break;
        case CodeBlockType.literals:
          count = ref.watch(tabCountProvider.select((s) => s.literals));
          break;
        case CodeBlockType.conditionals:
          count = ref.watch(tabCountProvider.select((s) => s.conditionals));
          break;
        case CodeBlockType.loops:
          count = ref.watch(tabCountProvider.select((s) => s.loops));
          break;
        case CodeBlockType.statement:
          break;
      }
      return Tab(
        text: '${selectedBlocks.keys.elementAt(i).formalName()} ($count)',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild == true) {
      buildTabs(); // cant put in initState, because it needs to access providerScope.
      firstBuild = false;
      setState(() {});
    }
    return BLDialog(
        child: Column(
      children: [
        const BLText(
          'Select the blocks that will be used in this challenge.',
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 15),
        TabBar(
          tabAlignment: TabAlignment.center,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          controller: tabController,
          tabs: tabs,
        ),
        Flexible(
          child: TabBarView(
              controller: tabController,
              children: List.generate(tabs.length, (i) {
                final key = selectedBlocks.entries.elementAt(i).key;
                final category = selectedBlocks.entries.elementAt(i).value;
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Expanded(
                        child: Wrap(
                            children: List.generate(category.length, (j) {
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: BlockDesignWrapper(
                                updateSelection: () {},
                                data: category[j],
                                text: category[j].name,
                                child: const SizedBox(
                                  height: 50,
                                  width: 70,
                                ),
                              ),
                            ),
                          );
                          // return SizedBox(
                          //   width: 200,
                          //   child: BLText(blockCategory[j].name),
                          // );
                        })),
                      ),
                      BlockSelectorAddBtn(type: key, addCustom: addCustom)
                    ],
                  ),
                );
              })),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const AdminBackBtn(),
            const SizedBox(
              width: 15,
            ),
            BLAdminButton(
              type: AdminBtnType.green,
              child: const BLText('Save changes'),
              onPressed: () {
                nav.pop(context, selectedBlocks);
              },
            )
          ],
        )
      ],
    ));
  }
}
