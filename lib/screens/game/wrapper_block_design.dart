import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockDesignWrapper extends ConsumerWidget {
  const BlockDesignWrapper(
      {required this.child, required this.data, this.color, super.key});
  final GameBlockData data;
  final Color? color;
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blui = ref.read(bluiProvider);
    return Material(
      color: Colors.transparent,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: data.state == CodeBlockState.selected
                ? Border.all(color: Colors.grey.shade700)
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: color ?? blui.getBlockColor(data.type),
          ),
          child: child),
    );
  }
}
