import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/testing.dart';
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
  final double? width;
  final double? height;
  final Alignment? alignment;

  const BlockDesignWrapper({
    required this.data,
    this.alignment,
    this.child,
    this.width,
    this.height,
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
            width: width,
            height: height,
            alignment: alignment,
            padding: EdgeInsets.symmetric(horizontal: data.name.length <= 3 ? 15 : 10, vertical: 8),
            decoration: BoxDecoration(
              border: data.state == CodeBlockState.inEditor ? Border.all(color: Colors.grey.shade700) : null,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: blui.getBlockColor(data.type).withOpacity(opacity),
            ),
            child: updateSelection != null || kIsWeb
                ? BLText(
                    data.name,
                    color: data.type != CodeBlockType.keywords ? Colors.white.withOpacity(opacity) : Colors.black,
                  )
                : child),
      ),
    );
  }
}
