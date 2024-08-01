import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatementBox extends ConsumerStatefulWidget {
  const StatementBox({required this.firstBLock, super.key});
  final GameBlockData firstBLock;
  @override
  ConsumerState<StatementBox> createState() => _StatementBoxState();
}

class _StatementBoxState extends ConsumerState<StatementBox> {
  final validator = BlockValidator();
  late final GameManagerState gameManagerState;
  final List<Widget> blocks = [];
  GameBlockData? passedBlock;
  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    addBlock(widget.firstBLock);
    super.initState();
  }

  void addBlock(GameBlockData data) {
    final dataSelected = data.copyWith(state: CodeBlockState.selected);
    debugPrint('add block ${dataSelected.state}');
    blocks.add(Padding(
      padding: const EdgeInsets.all(3),
      child: GameBlock(data: dataSelected),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerStateProvider);
    return DragTarget(
      builder: (context, accepted, rejected) {
        if (blocks.isNotEmpty) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: blocks,
          );
        }
        return const BlankWidget();
      },
      onAcceptWithDetails: (details) {
        if (passedBlock == null) return;
        addBlock(passedBlock!);
        gameManagerState.removePassedBlockData();
      },
      onWillAcceptWithDetails: (details) {
        passedBlock = gameManagerState.obtainPassedBlockData();
        if (passedBlock == null) return false;
        // TODO: customize to accept custom blocks only
        return validator.rootStatementBox(data: passedBlock!);
      },
      onMove: (details) {},
      onLeave: (details) {},
    );
  }
}
