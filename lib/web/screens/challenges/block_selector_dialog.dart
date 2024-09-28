import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
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

class BlockSelectorDialog extends ConsumerStatefulWidget {
  final Map<CodeBlockType, List<GameBlockData>>? initialBlocks;
  const BlockSelectorDialog({required this.initialBlocks, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSelectorDialogState();
}

class _BlockSelectorDialogState extends ConsumerState<BlockSelectorDialog> with SingleTickerProviderStateMixin {
  late final Map<CodeBlockType, List<GameBlockData>>? selectedBlocks;
  late final List<Tab> tabs;
  late TabController tabController;
  late final DialogService dialog;
  late final CustomNavigation nav;
  late final Toast toast;
  bool processing = false;

  void addCustom(CodeBlockType type) async {
    if (processing) return;
    processing = false;
    final result = await dialog.show(context, barrierDismissable: false, CustomBlockDialog(type));
    if (result is GameBlockData) {
      if (!mounted) return;
      nav.pop(context, result);
    } else {
      if (!mounted) return;
      toast.showToast(context, 'No block added.', type: NotifType.info);
    }
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
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
                final key = selectedBlocks!.entries.elementAt(i).key;
                final category = selectedBlocks!.entries.elementAt(i).value;
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
                onPressed: () async {
                  if (processing) return;
                  processing = true;

                  processing = false;
                })
          ],
        )
      ],
    ));
  }

  @override
  void initState() {
    dialog = ref.read(dialogServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    selectedBlocks = widget.initialBlocks ?? {for (final type in CodeBlockType.values) type: []};
    tabController = TabController(vsync: this, length: selectedBlocks!.keys.length);
    tabs = List.generate(selectedBlocks!.keys.length, (i) {
      return Tab(
        text: selectedBlocks!.keys.elementAt(i).name,
      );
    });
    super.initState();
  }
}
