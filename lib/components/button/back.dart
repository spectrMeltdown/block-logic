import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBackButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final double paddingY;
  final bool disabled;
  const BLBackButton({this.onPressed, this.paddingY = 7, this.disabled = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final BLAudioState? audio;
    if (!kIsWeb) audio = ref.read(bLAudioStateProvider.notifier);
    final nav = ref.read(customNavigationProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingY, vertical: 0),
      child: IconButton(
          onPressed: () {
            if (disabled) return;
            audio?.playBtn();
            if (onPressed != null) {
              onPressed?.call();
            } else {
              nav.pop(context);
            }
          },
          icon: const Icon(
            FontAwesomeIcons.circleArrowLeft,
            size: 32,
          )),
    );
  }
}
