import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:block_logic/screens/game/blocks_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTabView extends ConsumerStatefulWidget {
  const CustomTabView({super.key});

  @override
  ConsumerState<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends ConsumerState<CustomTabView> {
  GameCodeBlockData? obtainedBlock;
  List<Widget> codeBlocks = [];
  bool addedPlaceholder = false;

  @override
  void initState() {
    super.initState();
  }

  void addBlock(GameCodeBlockData data) {
    final dataSelected = data.copyWith(state: CodeBlockState.selected);
    debugPrint('add block ${dataSelected.state}');
    codeBlocks.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: GameCodeBlock(data: dataSelected),
        )
      ],
    ));
  }

  void addPlaceholder(GameCodeBlockData data) {
    if (addedPlaceholder == true) return;
    final dataWithPlaceholder = data.copyWith(state: CodeBlockState.faded);
    debugPrint('add placeholder ${dataWithPlaceholder.state}');
    codeBlocks.add(GameCodeBlock(data: dataWithPlaceholder));
    addedPlaceholder = true;
  }

  void removePlaceholder() {
    if (addedPlaceholder == true) {
      codeBlocks.removeLast();
      debugPrint('removed, codeblocks empty = ${codeBlocks.isEmpty}');
      addedPlaceholder = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = ref.watch(gameManagerStateProvider);
    final gameManagerState = ref.read(gameManagerStateProvider.notifier);
    if (gameManager.isDropCancelled) {
      // TODO: if drop was cancelled, reverse to previous state of this widget
      gameManagerState.isDropCancelled(false);
      setState(() {});
    }
    return DragTarget(
      // rejected bypasses onMove
      builder: (context, accepted, rejected) {
        //debugPrint('builder called');
        if (codeBlocks.isNotEmpty) {
          return BlockWrapper(codeBlocks, topLevel: true);
        }
        return const Center(child: BLText('Drop a block'));
      },
      onWillAcceptWithDetails: (details) {
        debugPrint('onWillAcceptWithDetails called');
        obtainedBlock = gameManagerState.obtainBlock();
        if (obtainedBlock == null) return false;
        return obtainedBlock?.state == CodeBlockState.unselected;
      },
      onAcceptWithDetails: (details) {
        debugPrint('onAcceptWithDetails called');
        if (obtainedBlock == null) return;
        //removePlaceholder();
        addBlock(obtainedBlock!);
        //setState(() {});
      },
      onMove: (details) {
        //debugPrint('onMove called');
        if (obtainedBlock == null) return;
        //addPlaceholder(obtainedBlock!);
        //setState(() {});
      },
      onLeave: (details) {
        debugPrint('onLeave called');
        //removePlaceholder();
        //setState(() {});
      },
    );
  }
}
