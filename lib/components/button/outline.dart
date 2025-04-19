import 'package:animate_do/animate_do.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:flutter/foundation.dart';
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
    BLAudioState? audio;
    if (!kIsWeb) {
      audio = ref.read(bLAudioStateProvider.notifier);
    }
    final blui = ref.read(bLUIProvider.notifier);
    // final random = ref.read(randomNumProvider.notifier);

    return Bounce(
      duration: Duration(milliseconds: getRandomInt(400, 600)),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Adjust the radius for rounded corners
              ),
              backgroundColor: blui.getBtnColor(type).withValues(alpha: 0.1),
              side: BorderSide(color: blui.getBtnColor(type))),
          onPressed: () {
            audio?.playBtn();
            onPressed.call();
          },
          child: Padding(padding: padding ?? EdgeInsets.symmetric(horizontal: paddingX ?? 0, vertical: paddingY ?? 0), child: child)),
    );
  }
}
