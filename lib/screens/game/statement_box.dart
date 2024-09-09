import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatementBox extends ConsumerStatefulWidget {
  final GameBlockData firstBLock;
  const StatementBox({required this.firstBLock, super.key});
  @override
  ConsumerState<StatementBox> createState() => _StatementBoxState();
}

class _StatementBoxState extends ConsumerState<StatementBox> {
  final validator = BlockValidator();
  late final GameManager gameManager;
  final List<Widget> blocks = [];
  GameBlockData? passedBlock;
  void addBlock(GameBlockData data) {
    final dataSelected = data.copyWith(state: CodeBlockState.inEditor);
    debugPrint('add block ${dataSelected.state}');
    blocks.add(Padding(
      padding: const EdgeInsets.all(3),
      child: GameBlock(data: dataSelected),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerProvider);
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
        gameManager.removePassedBlockData();
      },
      onWillAcceptWithDetails: (details) {
        passedBlock = gameManager.obtainPassedBlockData();
        if (passedBlock == null) return false;
        // TODO: customize to accept custom blocks only
        return validator.rootStatementBox(data: passedBlock!);
      },
      onMove: (details) {},
      onLeave: (details) {},
    );
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    addBlock(widget.firstBLock);
    super.initState();
  }
}
