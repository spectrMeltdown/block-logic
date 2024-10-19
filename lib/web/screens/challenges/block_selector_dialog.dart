import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
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
  late final Map<CodeBlockType, List<GameBlockData>> selectedBlocks;
  late TabController tabController;
  late final DialogService dialog;
  late final CustomNavigation nav;
  late final TabCountManager counter;
  late final ChallengeManager chManager;
  late final Toast toast;
  bool processing = false;

  @override
  void initState() {
    dialog = ref.read(dialogServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    chManager = ref.read(challengeManagerProvider.notifier);
    counter = ref.read(tabCountProvider.notifier);
    // init
    selectedBlocks = {for (final type in CodeBlockType.values.where((e) => e != CodeBlockType.statement)) type: []};

    // copy the existing blocks to the selected blocks
    if (widget.initialBlocks.isNotEmpty) {
      for (final entry in widget.initialBlocks.entries) {
        selectedBlocks[entry.key] = entry.value;
        counter.assign(entry.key, selectedBlocks[entry.key]!.length);
      }
      // copyInitToSelected(); // assign variables, functions, etc blocks to selectedBlocks
    }

    // // fill in other blocks
    fillOtherBlocks();
    tabController = TabController(vsync: this, length: selectedBlocks.keys.length);
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
        if (selectedBlocks[type] != null) {
          customBlocks.addAll(selectedBlocks[type]!);
        }
      default:
    }
    dPrint(customBlocks.toString());
    final data = await dialog.show(context, barrierDismissable: false, CustomBlockDialog(type, customBlocks: customBlocks));
    if (data is GameBlockData) {
      if (!mounted) return;
      selectedBlocks[type]!.add(data);
      counter.increment(type);
      setState(() {});
    } else {
      if (!mounted) return;
      // toast.showToast(context, 'No block added.', type: NotifType.info);
    }
  }

  // void copyInitToSelected() {
  //   for (final codeType in CodeBlockType.values) {
  //     switch (codeType) {
  //       case CodeBlockType.variables:
  //       case CodeBlockType.functions:
  //       case CodeBlockType.objects:
  //       case CodeBlockType.literals:
  //         if (widget.initialBlocks[codeType] != null) {
  //           selectedBlocks[codeType] ??= [];
  //           for (final data in widget.initialBlocks[codeType]!) {
  //             dPrint(codeType.name);
  //             selectedBlocks[codeType]!.add(data);
  //           }
  //         }
  //         break;
  //       default:
  //     }
  //   }
  // }

  void fillOtherBlocks() {
    for (final codeType in CodeBlockType.values) {
      switch (codeType) {
        case CodeBlockType.operators:
          for (final type in PyOperatorTypes.values) {
            switch (type) {
              case PyOperatorTypes.comparison:
                for (final operator in PyOperatorsComparison.values) {
                  final data = GameBlockData.createOperator(operatorType: type, operator: operator, count: 0);
                  if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
                    selectedBlocks[codeType]!.add(data);
                  }
                }
                break;
              case PyOperatorTypes.assignment:
                for (final operator in PyOperatorsAssignment.values) {
                  final data = GameBlockData.createOperator(operatorType: type, operator: operator, count: 0);
                  if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
                    selectedBlocks[codeType]!.add(data);
                  }
                }
                break;
              case PyOperatorTypes.arithmetic:
                for (final operator in PyOperatorsArithmetic.values) {
                  final data = GameBlockData.createOperator(operatorType: type, operator: operator, count: 0);
                  if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
                    selectedBlocks[codeType]!.add(data);
                  }
                }
                break;
              case PyOperatorTypes.identity:
                for (final operator in PyOperatorsIdentity.values) {
                  final data = GameBlockData.createOperator(operatorType: type, operator: operator, count: 0);
                  if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
                    selectedBlocks[codeType]!.add(data);
                  }
                }
                break;
              case PyOperatorTypes.membership:
                for (final operator in PyOperatorsMembership.values) {
                  final data = GameBlockData.createOperator(operatorType: type, operator: operator, count: 0);
                  if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
                    selectedBlocks[codeType]!.add(data);
                  }
                }
                break;
              case PyOperatorTypes.logical:
                for (final operator in PyOperatorsLogical.values) {
                  final data = GameBlockData.createOperator(operatorType: type, operator: operator, count: 0);
                  if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
                    selectedBlocks[codeType]!.add(data);
                  }
                }
                break;
            }
          }
          break;
        case CodeBlockType.keywords:
          for (final keyword in PyKeyword.values) {
            final data = GameBlockData.createKeyword(keyword: keyword, count: 0);
            if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
              selectedBlocks[codeType]!.add(data);
            }
          }
          break;
        case CodeBlockType.conditionals:
          for (final conditional in PyConditional.values) {
            final data = GameBlockData.createConditional(conditional: conditional, count: 0);
            if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
              selectedBlocks[codeType]!.add(data);
            }
          }
          break;
        case CodeBlockType.loops:
          for (final loop in PyLoop.values) {
            final data = GameBlockData.createLoop(loop: loop, count: 0);
            if (!selectedBlocks[codeType]!.any((e) => e.name == data.name)) {
              selectedBlocks[codeType]!.add(data);
            }
          }
          break;
        default:
      }
    }
  }

  ProviderListenable<int> getTabCount(CodeBlockType type) {
    late final ProviderListenable<int> listenable;
    switch (type) {
      case CodeBlockType.variables:
        listenable = tabCountProvider.select((s) => s.variables);
        break;
      case CodeBlockType.functions:
        listenable = tabCountProvider.select((s) => s.functions);
        break;
      case CodeBlockType.objects:
        listenable = tabCountProvider.select((s) => s.objects);
        break;
      case CodeBlockType.operators:
        listenable = tabCountProvider.select((s) => s.operators);
        break;
      case CodeBlockType.keywords:
        listenable = tabCountProvider.select((s) => s.keywords);
        break;
      case CodeBlockType.literals:
        listenable = tabCountProvider.select((s) => s.literals);
        break;
      case CodeBlockType.conditionals:
        listenable = tabCountProvider.select((s) => s.conditionals);
        break;
      case CodeBlockType.loops:
        listenable = tabCountProvider.select((s) => s.loops);
        break;
      case CodeBlockType.statement:
        break;
    }
    return listenable;
  }

  void updateCount({required GameBlockData data, bool add = true}) {
    final type = data.type;
    if (add) {
      final count = data.inSelectorCount;
      if (count != null) {
        if (count <= 100) {
          final newCount = count + 1;
          final newData = data.copyWith(inSelectorCount: newCount);
          final index = selectedBlocks[type]!.indexWhere((e) => e.name == data.name);
          selectedBlocks[type]![index] = newData;
          if (newCount == 1) counter.increment(type);
        } else {
          toast.showToast(context, 'Max count reached!!', type: NotifType.error);
        }
      }
    } else {
      // decrement
      final count = data.inSelectorCount;
      if (count != null && count > 0) {
        final newCount = count - 1;
        final newData = data.copyWith(inSelectorCount: newCount);
        final index = selectedBlocks[type]!.indexWhere((e) => e.name == data.name);
        selectedBlocks[type]![index] = newData;
        if (newCount == 0) counter.decrement(type);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            tabs: List.generate(selectedBlocks.keys.length, (i) {
              final type = CodeBlockType.values[i];
              final count = ref.watch(getTabCount(type));
              return Tab(
                text: '${selectedBlocks.keys.elementAt(i).capName()} ($count)',
              );
            }),
          ),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: List.generate(selectedBlocks.keys.length, (i) {
                  final key = selectedBlocks.entries.elementAt(i).key;
                  final category = selectedBlocks.entries.elementAt(i).value;
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        category.isEmpty
                            ? Expanded(
                                child: Center(
                                    child: BLText(
                                  'Nothing yet ...',
                                  size: 18,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                )),
                              )
                            : Expanded(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BLAdminButton(
                  type: AdminBtnType.red,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      BLText('Clear All')
                    ],
                  ),
                  onPressed: () {
                    for (final entry in selectedBlocks.entries) {
                      for (int i = 0; i < entry.value.length; i++) {
                        final data = entry.value[i];
                        if (data.inSelectorCount != null && data.inSelectorCount! > 0) {
                          selectedBlocks[entry.key]![i] = data.copyWith(inSelectorCount: 0);
                        }
                      }
                    }
                    ref.invalidate(tabCountProvider);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const AdminBackBtn(text: 'Cancel'),
                  const SizedBox(width: 15),
                  BLAdminButton(
                    type: AdminBtnType.green,
                    child: const BLText('Save changes'),
                    onPressed: () {
                      processing = true;
                      Map<CodeBlockType, List<GameBlockData>> blocksToReturn = {};
                      // loop through selected blocks categories
                      for (final entry in selectedBlocks.entries) {
                        // loop through current category
                        for (final block in entry.value) {
                          if (block.inSelectorCount != null && block.inSelectorCount! > 0) {
                            dPrint('count: ${block.inSelectorCount}');
                            if (blocksToReturn[entry.key] != null) {
                              blocksToReturn[entry.key]!.add(block);
                            } else {
                              blocksToReturn.addAll({
                                entry.key: [block]
                              });
                            }
                          }
                        }
                      }
                      dPrint('Blocks to return: $blocksToReturn');
                      nav.pop(context, blocksToReturn);
                      processing = false;
                    },
                  ),
                  const SizedBox(width: 15),
                ],
              )
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
              IntrinsicWidth(
                child: BlockDesignWrapper(
                  updateSelection: () {},
                  data: widget.data,
                  alignment: Alignment.center,
                  minWidth: 75,
                  minHeight: 50,
                  maxWidth: 200,
                  opacity: widget.data.inSelectorCount == null || widget.data.inSelectorCount! < 1 ? 0.3 : 1,
                ),
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
                        onTap: () => widget.updateCount(data: widget.data, add: false),
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
                bold: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
