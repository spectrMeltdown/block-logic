import 'package:block_logic/logic/audio.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBackButton extends StatefulWidget {
  const BLBackButton({super.key});

  @override
  State<BLBackButton> createState() => _BLBackButtonState();
}

class _BLBackButtonState extends State<BLBackButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: IconButton(
          onPressed: () {
            BLAudio.playBtn();
            Utils.pop(context);
          },
          icon: const Icon(
            FontAwesomeIcons.circleArrowLeft,
            size: 32,
          )),
    );
  }
}
