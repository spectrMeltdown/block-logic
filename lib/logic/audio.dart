import 'package:block_logic/logic/assets.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BLAudio {
  static void playBtn() {
    // TODO: Get soundEffects pref
    bool soundEffects = true;
    if (soundEffects == true) FlameAudio.play(Assets.btn1);
  }

  static void toggleSoundEffects() {
    // TODO: Get soundEffects pref
  }
  static void playBG() {
    bool bgMusic = true;
    if (bgMusic == true) FlameAudio.play(Assets.btn1);
  }
}
