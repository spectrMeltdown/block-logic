import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockDesignWrapper extends ConsumerWidget {
  final GameBlockData data;
  final Color? color;
  final Widget child;
  final String? text;
  final void Function()? updateSelection;
  const BlockDesignWrapper({
    required this.child,
    required this.data,
    this.color,
    this.updateSelection,
    this.text,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blui = ref.read(bLUIProvider.notifier);
    return ZoomIn(
      duration: Duration(milliseconds: getRandomInt(300, 500)),
      child: Material(
        color: Colors.transparent,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: data.name.length <= 3 ? 15 : 10, vertical: 8),
            decoration: BoxDecoration(border: data.state == CodeBlockState.inEditor ? Border.all(color: Colors.grey.shade700) : null, borderRadius: const BorderRadius.all(Radius.circular(10)), color: blui.getBlockColor(data.type)),
            child: updateSelection != null
                ? BLText(
                    text!,
                    color: Colors.white,
                  )
                : child),
      ),
    );
  }
}
