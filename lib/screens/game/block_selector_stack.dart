import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorStack extends ConsumerStatefulWidget {
  final GameBlockData data;
  const BlockSelectorStack(this.data, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockSelectorStackState();
}

class _BlockSelectorStackState extends ConsumerState<BlockSelectorStack> {
  late int count;
  late final GameManager manager;
  @override
  void initState() {
    count = widget.data.inSelectorCount!;
    manager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  void updateCount({
    bool add = true,
  }) {
    if (add) {
      setState(() {
        count++;
      });
    } else {
      setState(() {
        count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool shouldReset = ref.watch(gameManagerProvider.select((state) => state.shouldRedisplay));
    if (shouldReset) {
      setState(() {
        count = widget.data.inSelectorCount!;
      });
      manager.setshouldRedisplay(false);
    }
    if (count > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(count, (i) {
            return GameBlock(
              data: widget.data,
              updateCount: updateCount,
            );
          }),
          Positioned(
              top: -3,
              right: -3,
              child: Badge(
                backgroundColor: Colors.white,
                label: BLText(
                  count.toString(),
                  bold: true,
                  color: Colors.black,
                  size: 13,
                ),
              ))
        ],
      );
    } else {
      return BlankWidget();
    }
  }
}
