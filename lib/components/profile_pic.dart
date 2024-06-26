import 'package:block_logic/logic/audio.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BLProfilePic extends StatefulWidget {
  const BLProfilePic({super.key, this.size = 50, this.onPressed});
  final double size;
  final VoidCallback? onPressed;

  @override
  State<BLProfilePic> createState() => _BLProfilePicState();
}

class _BLProfilePicState extends State<BLProfilePic> {
  final db = DBService();
  double _opacity = 0;
  bool _isTapped = false;

  void onTapUp(TapUpDetails tapUp) {
    setState(() {
      _isTapped = false;
      _opacity = 0;
    });
    widget.onPressed?.call();
  }

  void onTapDown(TapDownDetails tapDown) {
    setState(() {
      _isTapped = true;
      _opacity = 1;
    });
    BLAudio.playBtn();
  }

  void onTapCancel() {
    setState(() {
      _isTapped = false;
      _opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    DBService db = Provider.of<DBService>(context);

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
            child: Consumer<User?>(
              builder: (context, user, child) {
                return CircleAvatar(
                  child: (user != null ? Icon(FontAwesomeIcons.placeOfWorship) : Icon(FontAwesomeIcons.user)),
                );
              },
            ),
          ),
          AnimatedOpacity(
              duration: Durations.short3,
              curve: Curves.easeInOut,
              opacity: _opacity,
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
