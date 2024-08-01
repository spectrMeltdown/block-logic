import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorView extends ConsumerStatefulWidget {
  const BlockSelectorView({required this.blocks, super.key});
  final List<GameBlock> blocks;
  @override
  ConsumerState<BlockSelectorView> createState() => _BlockSelectorViewState();
}

class _BlockSelectorViewState extends ConsumerState<BlockSelectorView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: SpacedRow(
          spacing: 10,
          children: widget.blocks,
        ),
      ),
    );
  }
}
