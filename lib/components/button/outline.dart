import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLOutlineButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final Widget child;
  final BtnType type;
  final EdgeInsets? padding;
  final double? paddingX;
  final double? paddingY;
  const BLOutlineButton({
    required this.onPressed,
    required this.child,
    required this.type,
    this.padding,
    this.paddingX,
    this.paddingY,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.read(bLAudioStateProvider.notifier);
    final blui = ref.read(bLUIProvider);
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: blui.getBtnColor(type))),
        onPressed: () {
          audio.playBtn();
          onPressed.call();
        },
        child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                    horizontal: paddingX ?? 0, vertical: paddingY ?? 0),
            child: child));
  }
}
