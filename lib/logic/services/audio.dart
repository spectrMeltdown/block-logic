import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/audio.g.dart';

@riverpod
Future<void> audioInit(AudioInitRef ref) async {
  final assets = ref.read(assetsProvider);
// cache assets for faster loading
  await FlameAudio.audioCache.loadAll([assets.audioBG1]);
}

@Riverpod(dependencies: [])
class BLAudio extends _$BLAudio {
  late bool _soundEffects;
  late bool _backgroundMusic;
  late SharedPreferences _sharedPref;
  late Assets _assets;

  // BLAudio({required bool _soundEffects, required bool _backgroundMusic})
  //     : _soundEffects = _soundEffects,
  //       _backgroundMusic = _backgroundMusic;

  @override
  BLAudio build() {
    _assets = ref.watch(assetsProvider);
    _sharedPref = ref.watch(sharedPrefProvider);
    _soundEffects = _sharedPref.getBool('_soundEffects') ?? true;
    _backgroundMusic = _sharedPref.getBool('_backgroundMusic') ?? true;
    return BLAudio();
    // return BLAudio(
    //     _soundEffects: _soundEffects, _backgroundMusic: _backgroundMusic);
  }

  void playBtn() {
    if (state._soundEffects == true) FlameAudio.play(_assets.btn1);
  }

  bool shouldPlaySoundEffects() {
    return state._soundEffects;
  }

  bool shouldPlayBackgroundMusic() {
    return state._backgroundMusic;
  }

  void toggleSoundEffects() {
    /// toggle the sound effects
    state._soundEffects = !state._soundEffects;

    /// save the user preference
    _sharedPref.setBool('_soundEffects', state._soundEffects);
  }

  void toggleBG() {
    /// reverse current value
    state._backgroundMusic = !state._backgroundMusic;

    /// check if should play
    if (state._backgroundMusic == true) {
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
        FlameAudio.bgm.play(_assets.audioBG1);
      }
    } else {
      /// pause the audio
      FlameAudio.bgm.pause();
    }

    /// save the new value
    _sharedPref.setBool('_backgroundMusic', state._backgroundMusic);
  }
}
