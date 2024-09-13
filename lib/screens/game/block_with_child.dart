import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/custom_box.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_blocks.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GameBox { parameters, arguments, conditions }

class GameBlockWithChild extends ConsumerStatefulWidget {
  // final String uid;
  final GameBlockData data;
  final GameBox? box;
  final VoidCallback refresh;
  const GameBlockWithChild({
    // required this.uid,
    required this.data,
    this.box,
    required this.refresh,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameBlockWithChildState();
}

class _GameBlockWithChildState extends ConsumerState<GameBlockWithChild> {
  final BlockValidator validator = BlockValidator();
  late final GameManager gameManager;
  List<GameBlockData> data = [];

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final widget.data = ref.watch(GetSelfDataProvider(widget.data.uid!));
    final data = ref.watch(GetChildrenDataProvider(widget.data.bodyUIDs ?? []));
    // final body = gameManager.getChildrenData(widget.data.bodyUIDs!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BLText(widget.data.name),
            const SizedBox(width: 20),
            if (shouldRenderBox(widget.data))
              CustomBox(
                data: widget.data,
                box: widget.box!,
              ),
            // if (widget.data.bodyUIDs != null) const BLText(' :')
          ],
        ),
        if (widget.data.bodyUIDs != null)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlockWrapper(
                  widgetList: List.generate(
                    data.length,
                    (i) => GameBlock(
                      data: data[i],
                    ),
                  ),
                ),
                DragTargetWrapper(
                  builderChild: () {
                    return const AddNewBlockBox(width: 120);
                  },
                  onAcceptWithDetails: (initData, manager) {
                    if (initData.state == CodeBlockState.inEditor) {
                      gameManager.moveData(initData.uid!, widget.data.uid!);
                    } else {
                      // debugPrint('Parent: ${widget.data.uid}');
                      gameManager.addData(initData, widget.data.uid!, ChildrenData.body);
                    }
                    ref.invalidate(getRootDataProvider);
                    ref.invalidate(getSelfDataProvider);
                    ref.invalidate(getChildrenDataProvider);
                    setState(() {});
                  },
                  onWillAcceptWithDetails: (initData) {
                    if (widget.data.bodyUIDs!.contains(initData.uid) ||
                        initData.uid == widget.data.uid ||
                        initData.uid == widget.data.parentUID) {
                      return false;
                    }
                    return true;
                    // return validator.bodyBox(data: widget.data, dataToAccept: initData);
                  },
                )
              ],
            ),
          )
      ],
    );
  }

  bool shouldRenderBox(GameBlockData data) {
    if (data.name == 'else') return false;
    if (data.name.contains('class')) return false;
    return true;
    // switch (data.type) {
    //   case CodeBlockType.literals:
    //   case CodeBlockType.conditionals:
    //   case CodeBlockType.loops:
    //   case CodeBlockType.functions:
    //   case CodeBlockType.objects:

    //   case CodeBlockType.keywords:

    //   case CodeBlockType.variables:

    //   case CodeBlockType.operators:

    //   case CodeBlockType.statement:

    // }
  }
}
