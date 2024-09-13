import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/screens/game/add_new_block_box.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:block_logic/screens/game/wrapper_drag_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatementBox extends ConsumerStatefulWidget {
  final GameBlockData data;
  const StatementBox({required this.data, super.key});
  @override
  ConsumerState<StatementBox> createState() => _StatementBoxState();
}

class _StatementBoxState extends ConsumerState<StatementBox> {
  final validator = BlockValidator();
  late final GameManager gameManager;
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(GetSelfDataProvider(widget.data.uid!));
    final blocks = ref.watch(GetChildrenDataProvider(data.statementUIDs!));
    // debugPrint(blocks.toString());
    // debugPrint('${widget.data.name} ${widget.data.statementUIDs}');

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            blocks.length,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GameBlock(data: blocks[i]),
            ),
          ),
          DragTargetWrapper(
            builderChild: () {
              return const AddNewBlockBox(height: 30, width: 30);
              // return AddNewBlockBox();
            },
            onAcceptWithDetails: (initData, manager) {
              debugPrint(initData.state.toString());
              if (initData.state == CodeBlockState.inEditor) {
                gameManager.moveData(initData.uid!, widget.data.uid!);
              } else {
                debugPrint('parent id: ${widget.data.uid}');
                debugPrint('initData name: ${initData.name}');
                gameManager.addData(initData, widget.data.uid!, ChildrenData.statement);
              }
              ref.invalidate(getRootDataProvider);
              ref.invalidate(getSelfDataProvider);
              ref.invalidate(getChildrenDataProvider);
              // debugPrint(gameManager.getRootData().toString());
              setState(() {});
            },
            onWillAcceptWithDetails: (initData) {
              if (widget.data.statementUIDs!.contains(initData.uid) ||
                  initData.uid == widget.data.uid ||
                  initData.uid == widget.data.parentUID) {
                return false;
              }
              return true;
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
