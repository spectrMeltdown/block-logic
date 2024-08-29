import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/screens/game/wrapper_block_design.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorDialog extends ConsumerStatefulWidget {
  final Map<CodeBlockType, List<GameBlockData>>? blocks;
  const BlockSelectorDialog(this.blocks, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSelectorDialogState();
}

class _BlockSelectorDialogState extends ConsumerState<BlockSelectorDialog> with SingleTickerProviderStateMixin {
  final Map<CodeBlockType, List<GameBlockData>> allBlocks = AllBlocks.getAll();
  late final List<Tab> tabs;
  late TabController tabController;
  bool processing = false;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      children: [
        const BLText('Select the blocks that will be used in this challenge.'),
        const SizedBox(height: 15),
        ClipRRect(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: Colors.blue.shade900,
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              controller: tabController,
              tabs: tabs,
            ),
          ),
        ),
        Flexible(
          child: TabBarView(
              controller: tabController,
              children: List.generate(tabs.length, (i) {
                final blockCategory = allBlocks.values.elementAt(i);
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Wrap(
                          children: List.generate(blockCategory.length, (j) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = !selected;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: BlockDesignWrapper(
                                selected: selected,
                                data: blockCategory[j],
                                child: SizedBox(
                                    height: 50,
                                    width: 70,
                                    child: Center(
                                        child: BLText(
                                      blockCategory[j].name,
                                    )))),
                          ),
                        );
                        // return SizedBox(
                        //   width: 200,
                        //   child: BLText(blockCategory[j].name),
                        // );
                      })),
                    ],
                  ),
                );
              })),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const AdminBackBtn(useContext: false),
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
    tabController = TabController(vsync: this, length: allBlocks.keys.length);
    tabs = List.generate(allBlocks.keys.length, (i) {
      return Tab(
        text: allBlocks.keys.elementAt(i).name,
      );
    });
    super.initState();
  }
}
