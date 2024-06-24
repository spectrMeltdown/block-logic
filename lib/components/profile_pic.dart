import 'package:block_logic/game/assets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLProfilePic extends StatefulWidget {
  const BLProfilePic({super.key, this.size = 50, this.onPressed});
  final double size;
  final VoidCallback? onPressed;

  @override
  State<BLProfilePic> createState() => _BLProfilePicState();
}

class _BLProfilePicState extends State<BLProfilePic> {
  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    bool isTapped = false;

    void onTapUp(TapUpDetails tapUp) {
      setState(() {
        isTapped = false;
        opacity = 0;
      });
      widget.onPressed?.call();
    }

    void onTapDown(TapDownDetails tapDown) {
      setState(() {
        isTapped = true;
        opacity = 1;
      });
      FlameAudio.play(Assets.btn1);
    }

    void onTapCancel() {
      setState(() {
        isTapped = false;
        opacity = 0;
      });
    }

    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[300],
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: const CircleAvatar(
              child: Icon(FontAwesomeIcons.user),
            ),
          ),
          AnimatedOpacity(
              duration: Durations.short3,
              curve: Curves.easeInOut,
              opacity: opacity,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100), borderRadius: const BorderRadius.all(Radius.circular(100))),
              )),
        ],
      ),
    );
  }
}
