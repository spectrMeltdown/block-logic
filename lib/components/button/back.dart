import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBackButton extends ConsumerStatefulWidget {
  final VoidCallback? onPressed;
  final double paddingY;
  final bool disabled;
  const BLBackButton({this.onPressed, this.paddingY = 7, this.disabled = false, super.key});

  @override
  ConsumerState<BLBackButton> createState() => _BLBackButtonState();
}

class _BLBackButtonState extends ConsumerState<BLBackButton> {
  BLAudioState? audio;
  late final CustomNavigation nav;

  @override
  void initState() {
    if (!kIsWeb) audio = ref.read(bLAudioStateProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingY, vertical: 0),
      child: IconButton(
          onPressed: () {
            if (widget.disabled) return;
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
