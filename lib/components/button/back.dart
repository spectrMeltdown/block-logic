import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBackButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  const BLBackButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.read(bLAudioStateProvider.notifier);
    final nav = ref.read(customNavigationProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: IconButton(
          onPressed: () {
            audio.playBtn();
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
