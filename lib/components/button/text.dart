import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLTextButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  const BLTextButton({required this.onPressed, required this.child, super.key});

  @override
  ConsumerState<BLTextButton> createState() => _BLTextButtonState();
}

class _BLTextButtonState extends ConsumerState<BLTextButton> {
  @override
  Widget build(BuildContext context) {
    BLAudioState? audio;
    if (!kIsWeb) {
      audio = ref.read(bLAudioStateProvider.notifier);
    }
    return TextButton(
        onPressed: () {
          audio?.playBtn();
          widget.onPressed.call();
        },
        child: widget.child);
  }
}
