import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockDesignWrapper extends ConsumerWidget {
  final bool? selected;
  final GameBlockData data;
  final Color? color;
  final Widget child;
  const BlockDesignWrapper({required this.child, required this.data, this.color, this.selected, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blui = ref.read(bLUIProvider.notifier);
    return Material(
      color: Colors.transparent,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: data.state == CodeBlockState.selected ? Border.all(color: Colors.grey.shade700) : null,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: color == null
                ? kIsWeb
                    ? selected != null && selected == false
                        ? blui.getBlockColor(data.type).withOpacity(0.3)
                        : blui.getBlockColor(data.type)
                    : null
                : null,
          ),
          child: child),
    );
  }
}
