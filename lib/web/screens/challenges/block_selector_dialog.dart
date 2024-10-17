import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/py_conditional.dart';
import 'package:block_logic/logic/game/py_keyword.dart';
import 'package:block_logic/logic/game/py_loops.dart';
import 'package:block_logic/logic/game/py_operators.dart';
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
  final Map<CodeBlockType, List<GameBlockData>> selectedBlocks = {};
  late final Map<CodeBlockType, List<GameBlockData>> togglableBlocks;
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
    togglableBlocks = {for (final type in CodeBlockType.values.where((e) => e != CodeBlockType.statement)) type: []};
    inittogglableBlocks(); // assign the default loops, conditionals, etc blocks to togglableBlocks
    if (widget.initialBlocks.isNotEmpty) {
      for (final entry in widget.initialBlocks.entries) {
        selectedBlocks[entry.key] = entry.value;
        counter.assign(entry.key, selectedBlocks[entry.key]!.length);
      }
      copySelectedToDefault(); // assign variables, functions, etc blocks to togglableBlocks
    }
    tabController = TabController(vsync: this, length: togglableBlocks.keys.length);
    super.initState();
  }

  void addCustom(CodeBlockType type) async {
    final List<GameBlockData> customBlocks = [];
    // grab the customBlocks that already exists
    switch (type) {
      case CodeBlockType.variables:
      case CodeBlockType.functions:
      case CodeBlockType.objects:
      case CodeBlockType.literals:
        if (togglableBlocks[type] != null) {
          customBlocks.addAll(togglableBlocks[type]!);
        }
      default:
    }
    final data = await dialog.show(context, barrierDismissable: false, CustomBlockDialog(type, customBlocks: customBlocks));
    if (data is GameBlockData) {
      if (!mounted) return;
      togglableBlocks[type]!.add(data);
      if (selectedBlocks[type] != null) {
        selectedBlocks[type]!.add(data);
      }
    } else {
      if (!mounted) return;
      // toast.showToast(context, 'No block added.', type: NotifType.info);
    }
  }

  void copySelectedToDefault() {
    for (final codeType in CodeBlockType.values) {
      switch (codeType) {
        case CodeBlockType.variables:
        case CodeBlockType.functions:
        case CodeBlockType.objects:
        case CodeBlockType.literals:
          if (widget.initialBlocks[codeType] != null) {
            for (final data in widget.initialBlocks[codeType]!) {
              togglableBlocks[codeType]!.add(data);
            }
          }
          break;
        default:
      }
    }
  }

  void inittogglableBlocks() {
    for (final codeType in CodeBlockType.values) {
      switch (codeType) {
        case CodeBlockType.operators:
          for (final type in PyOperatorTypes.values) {
            switch (type) {
              case PyOperatorTypes.comparison:
                for (final operator in PyOperatorsComparison.values) {
                  togglableBlocks[codeType]!.add(GameBlockData.createOperator(operatorType: type, operator: operator));
                }
                break;
              case PyOperatorTypes.assignment:
                for (final operator in PyOperatorsAssignment.values) {
                  togglableBlocks[codeType]!.add(GameBlockData.createOperator(operatorType: type, operator: operator));
                }
                break;
              case PyOperatorTypes.arithmetic:
                for (final operator in PyOperatorsArithmetic.values) {
                  togglableBlocks[codeType]!.add(GameBlockData.createOperator(operatorType: type, operator: operator));
                }
                break;
              case PyOperatorTypes.identity:
                for (final operator in PyOperatorsIdentity.values) {
                  togglableBlocks[codeType]!.add(GameBlockData.createOperator(operatorType: type, operator: operator));
                }
                break;
              case PyOperatorTypes.membership:
                for (final operator in PyOperatorsMembership.values) {
                  togglableBlocks[codeType]!.add(GameBlockData.createOperator(operatorType: type, operator: operator));
                }
                break;
              case PyOperatorTypes.logical:
                for (final operator in PyOperatorsLogical.values) {
                  togglableBlocks[codeType]!.add(GameBlockData.createOperator(operatorType: type, operator: operator));
                }
                break;
            }
          }
          break;
        case CodeBlockType.keywords:
          for (final keyword in PyKeyword.values) {
            togglableBlocks[codeType]!.add(GameBlockData.createKeyword(keyword: keyword));
          }
          break;
        case CodeBlockType.conditionals:
          for (final conditional in PyConditional.values) {
            togglableBlocks[codeType]!.add(GameBlockData.createConditional(conditional: conditional));
          }
          break;
        case CodeBlockType.loops:
          for (final loop in PyLoop.values) {
            togglableBlocks[codeType]!.add(GameBlockData.createLoop(loop: loop));
          }
          break;
        default:
      }
    }
  }

  void buildTabs() {
    tabs = List.generate(togglableBlocks.keys.length, (i) {
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
        text: '${togglableBlocks.keys.elementAt(i).formalName()} ($count)',
      );
    });
  }

  void updateCount({required GameBlockData data, bool add = true}) {
    final type = data.type;
    if (add) {
      final newData = data.copyWith(inSelectorCount: data.inSelectorCount != null ? data.inSelectorCount! + 1 : 1);
      if (selectedBlocks[type] != null) {
        selectedBlocks[type]!.add(newData);
      } else {
        selectedBlocks.addAll({
          type: [newData]
        });
      }
    } else {
      // decrement
      final newData = data.copyWith(inSelectorCount: data.inSelectorCount != null ? data.inSelectorCount! - 1 : 0);
      final index = selectedBlocks[type]!.indexWhere((e) => e.name == data.name);
      selectedBlocks[type]![index] = newData;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (firstBuild == true) {
      buildTabs(); // cant put in initState, because it needs to access providerScope.
      firstBuild = false;
      setState(() {});
    }
    return BLDialog(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: 500,
            child: const BLText(
              'Select the blocks that will be used in this challenge:',
              softWrap: true,
              alignCenter: true,
              color: Colors.white,
              size: 20,
            ),
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
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: List.generate(tabs.length, (i) {
                  final key = togglableBlocks.entries.elementAt(i).key;
                  final category = togglableBlocks.entries.elementAt(i).value;
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView(
                          children: [
                            Wrap(
                                spacing: 20,
                                runSpacing: 30,
                                children: List.generate(category.length, (j) {
                                  final data = category[j];
                                  return BlockItem(data: data, updateCount: updateCount);
                                })),
                          ],
                        )),
                        SizedBox(height: 20),
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
              const SizedBox(width: 15),
              BLAdminButton(
                type: AdminBtnType.green,
                child: const BLText('Save changes'),
                onPressed: () {
                  nav.pop(context, selectedBlocks);
                },
              ),
              const SizedBox(width: 15),
            ],
          )
        ],
      ),
    ));
  }
}

class BlockItem extends ConsumerStatefulWidget {
  final GameBlockData data;
  final void Function({required GameBlockData data, bool add}) updateCount;
  const BlockItem({required this.data, required this.updateCount, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockItemState();
}

class _BlockItemState extends ConsumerState<BlockItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              BlockDesignWrapper(
                updateSelection: () {},
                data: widget.data,
                alignment: Alignment.center,
                width: 75,
                height: 50,
                opacity: widget.data.inSelectorCount == null || widget.data.inSelectorCount! < 1 ? 0.3 : 1,
              ),
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () => widget.updateCount(data: widget.data, add: true),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.green,
                          child: Icon(Icons.add_circle_rounded),
                        )),
                    GestureDetector(
                        onTap: () {
                          // remove count here
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.red,
                          child: Icon(Icons.remove_circle),
                        )),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: -3,
            right: -3,
            child: Badge(
              backgroundColor: Colors.white,
              label: BLText(
                '${widget.data.inSelectorCount ?? 0}',
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
