import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/blocks_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedGameBlock extends ConsumerStatefulWidget {
  const SelectedGameBlock(this.data, {super.key});
  final GameCodeBlockData data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectedGameBlockState();
}

class _SelectedGameBlockState extends ConsumerState<SelectedGameBlock> {
  GameCodeBlockData? block;
  List<Widget> blocks = [];

  void addBlock(GameCodeBlockData data) {
    final dataSelected = data.copyWith(state: CodeBlockState.selected);
    debugPrint('add block ${dataSelected.state}');
    blocks.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: GameCodeBlock(data: dataSelected),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gameManagerStateProvider);
    final gameManager = ref.watch(gameManagerStateProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BLText(widget.data.name ?? ''),
        DragTarget(
          builder: (context, accepted, rejected) {
            if (blocks.isNotEmpty) {
              return BlockWrapper(blocks);
            }
            return const SizedBox(width: 100, height: 50);
          },
          onAcceptWithDetails: (details) {
            if (block == null) return;
            addBlock(block!);
          },
          onWillAcceptWithDetails: (details) {
            block = gameManager.obtainBlock();
            if (block == null) return false;
            return block!.state != CodeBlockState.selected;
          },
          onMove: (details) {},
          onLeave: (details) {},
        )
      ],
    );
  }
}
