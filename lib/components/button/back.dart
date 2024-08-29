import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBackButton extends ConsumerStatefulWidget {
  final VoidCallback? onPressed;
  const BLBackButton({this.onPressed, super.key});

  @override
  ConsumerState<BLBackButton> createState() => _BLBackButtonState();
}

class _BLBackButtonState extends ConsumerState<BLBackButton> {
  BLAudioState? audio;
  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) audio = ref.read(bLAudioStateProvider.notifier);
    final nav = ref.read(customNavigationProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: IconButton(
          onPressed: () {
            audio?.playBtn();
            if (widget.onPressed != null) {
              widget.onPressed?.call();
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
