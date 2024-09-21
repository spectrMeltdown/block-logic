import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/audio.g.dart';

@Riverpod(keepAlive: true)
Future<void> audioInit(AudioInitRef ref) async {
  final assets = ref.read(assetsProvider);
// cache assets for faster loading
  await FlameAudio.audioCache.loadAll([assets.audioBG1]);
}

@Riverpod(keepAlive: true)
class BLAudioState extends _$BLAudioState {
  @override
  BLAudio build() {
    final assets = ref.watch(assetsProvider);
    final sharedPref = ref.watch(sharedPrefProvider);
    final soundEffects = sharedPref.getBool('soundEffects') ?? true;
    final backgroundMusic = sharedPref.getBool('backgroundMusic') ?? true;
    debugPrint('rebuild on blaudio');
    return BLAudio(
      soundEffects: soundEffects,
      backgroundMusic: backgroundMusic,
      sharedPref: sharedPref,
      assets: assets,
    );
    // return BLAudio(
    //     soundEffects: soundEffects, backgroundMusic: backgroundMusic);
  }

  void playBtn() {
    if (state.soundEffects) FlameAudio.play(state._assets.btn1);
  }

  void toggleSoundEffects() {
    /// toggle the sound effects
    state.soundEffects = !state.soundEffects;
    debugPrint(state.soundEffects.toString());

    /// save the user preference
    state._sharedPref.setBool('soundEffects', state.soundEffects);
  }

  void toggleBG() {
    /// reverse current value
    state.backgroundMusic = !state.backgroundMusic;

    /// check if should play
    if (state.backgroundMusic == true) {
      /// check if bgm is already playing
      if (!FlameAudio.bgm.isPlaying) {
        /// adjust the volume
        if (FlameAudio.bgm.audioPlayer.volume < 1) {
          FlameAudio.bgm.audioPlayer.setVolume(1);
        }

        /// resume the audio
        FlameAudio.bgm.resume();
      } else {
        /// play from start
        FlameAudio.bgm.play(state._assets.audioBG1);
      }
    } else {
      /// pause the audio
      FlameAudio.bgm.pause();
    }

    /// save the new value
    state._sharedPref.setBool('backgroundMusic', state.backgroundMusic);
  }
}

class BLAudio {
  bool soundEffects;
  bool backgroundMusic;
  final SharedPreferences _sharedPref;
  final Assets _assets;

  BLAudio({
    required this.soundEffects,
    required this.backgroundMusic,
    required SharedPreferences sharedPref,
    required Assets assets,
  })  : _sharedPref = sharedPref,
        _assets = assets;
}
