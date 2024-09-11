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
    final blocks = ref.watch(GetChildrenDataProvider(widget.data.bodyUIDs!));
    return DragTargetWrapper(
      builderChild: () {
        if (blocks.isNotEmpty) {
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...List.generate(blocks.length, (i) => GameBlock(data: blocks[i])),
            AddNewBlockBox(height: 40, width: 20)
          ]);
        }
        return AddNewBlockBox(height: 40, width: 20);
      },
      onAcceptWithDetails: (initData, manager) {
        if (initData.state == CodeBlockState.inEditor) {
          gameManager.moveData(initData.uid!, widget.data.uid!);
        } else {
          debugPrint('Parent: ${widget.data.uid}');
          gameManager.addData(initData, widget.data.uid!, ChildrenData.body);
        }
        // ref.invalidate(getSelfDataProvider);
        ref.invalidate(getChildrenDataProvider);
        setState(() {});
      },
      onWillAcceptWithDetails: (initData) {
        if (widget.data.bodyUIDs!.contains(initData.uid) || initData.uid == widget.data.uid) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }
}
