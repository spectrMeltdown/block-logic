import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
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
  final String uid;
  final GameBox box;
  final VoidCallback refresh;
  const GameBlockWithChild({required this.uid, required this.box, required this.refresh, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameBlockWithChildState();
}

class _GameBlockWithChildState extends ConsumerState<GameBlockWithChild> {
  final BlockValidator validator = BlockValidator();
  late final GameManager gameManager;

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(GetSelfDataProvider(widget.uid));
    final body = ref.watch(GetChildrenDataProvider(data.bodyUIDs!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BLText(data.name),
            const SizedBox(width: 20),
            CustomBox(
              data: data,
              box: widget.box,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DragTargetWrapper(
            builderChild: () {
              if (body.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlockWrapper(
                        widgetList: List.generate(
                            body.length,
                            (i) => GameBlock(
                                  data: body[i],
                                ))),
                    AddNewBlockBox(
                      width: 120,
                    )
                  ],
                );
              }
              return AddNewBlockBox(width: 120);
            },
            onAcceptWithDetails: (initData, manager) {
              if (initData.state == CodeBlockState.inEditor) {
                gameManager.moveData(initData.uid!, data.uid!);
              } else {
                debugPrint('Parent: ${data.uid}');
                gameManager.addData(initData, data.uid!, ChildrenData.body);
              }
              ref.invalidate(getSelfDataProvider);
              ref.invalidate(getChildrenDataProvider);
              setState(() {});
            },
            onWillAcceptWithDetails: (initData) {
              if (data.bodyUIDs!.contains(initData.uid) || initData.uid == data.uid) {
                return false;
              }
              return true;
              // return validator.nestedBox(data: data, dataToAccept: initData);
            },
          ),
        )
      ],
    );
  }
}
