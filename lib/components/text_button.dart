import 'package:block_logic/logic/audio.dart';
import 'package:flutter/material.dart';

class BLTextButton extends StatefulWidget {
  const BLTextButton({required this.onPressed, required this.child, super.key});
  final VoidCallback onPressed;
  final Widget child;

  @override
  State<BLTextButton> createState() => _BtnState();
}

class _BtnState extends State<BLTextButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          widget.onPressed.call();
          BLAudio.playBtn();
        },
        child: widget.child);
  }
}
