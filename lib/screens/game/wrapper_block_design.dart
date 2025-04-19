import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockDesignWrapper extends ConsumerWidget {
  final GameBlockData data;
  final Color? color;
  final Widget? child;
  // final String? text;
  final void Function()? updateSelection;
  final double opacity;
  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;
  final Alignment? alignment;

  const BlockDesignWrapper({
    required this.data,
    this.alignment,
    this.child,
    this.minWidth = 0,
    this.minHeight = 0,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
    this.opacity = 1,
    this.color,
    this.updateSelection,
    // this.text,
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
            constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth, maxHeight: maxHeight, maxWidth: maxWidth),
            alignment: alignment,
            padding: EdgeInsets.symmetric(horizontal: data.name.length <= 3 ? 15 : 10, vertical: 8),
            decoration: BoxDecoration(
              border: data.state == CodeBlockState.inEditor ? Border.all(color: Colors.grey.shade700) : null,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: blui.getBlockColor(data.type).withValues(alpha: opacity),
            ),
            child: updateSelection != null || kIsWeb
                ? BLText(
                    data.name,
                    size: kIsWeb ? 18 : null,
                    color: data.type != CodeBlockType.keywords ? Colors.white.withValues(alpha: opacity) : Colors.black,
                    softWrap: true,
                  )
                : child),
      ),
    );
  }
}
