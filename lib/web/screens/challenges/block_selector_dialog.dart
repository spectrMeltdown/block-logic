import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/block_data_manager.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/screens/challenges/add_custom_block.dart';
import 'package:block_logic/web/screens/challenges/block_selector_add_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorDialog extends ConsumerStatefulWidget {
  final Map<CodeBlockType, List<GameBlockData>>? blocks;
  const BlockSelectorDialog(this.blocks, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSelectorDialogState();
}

class _BlockSelectorDialogState extends ConsumerState<BlockSelectorDialog> with SingleTickerProviderStateMixin {
  final Map<CodeBlockType, List<GameBlockData>> allBlocks = AllBlocks().getAll();
  late final List<Tab> tabs;
  late TabController tabController;
  bool processing = false;
  late final DialogService dialog;
  void addObj() async {
    final result = await dialog.show(context, const CustomBlockDialog());
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
                final blockCategories = allBlocks.values.elementAt(i);
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Wrap(
                          children: List.generate(blockCategories.length, (j) {
                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: BlockDesignWrapper(
                              updateSelection: () {},
                              data: blockCategories[j],
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
                      BlockSelectorAddBtn(type: allBlocks.keys.toList()[i], addObj: addObj)
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
    tabController = TabController(vsync: this, length: allBlocks.keys.length);
    tabs = List.generate(allBlocks.keys.length, (i) {
      return Tab(
        text: allBlocks.keys.elementAt(i).name,
      );
    });
    super.initState();
  }
}
