import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLTextButton extends ConsumerStatefulWidget {
  const BLTextButton({required this.onPressed, required this.child, super.key});
  final VoidCallback onPressed;
  final Widget child;

  @override
  ConsumerState<BLTextButton> createState() => _BtnState();
}

class _BtnState extends ConsumerState<BLTextButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.read(bLAudioStateProvider.notifier);
    return TextButton(
        onPressed: () {
          audio.playBtn();
          widget.onPressed.call();
        },
        child: widget.child);
  }
}
