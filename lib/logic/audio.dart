import 'package:shared_preferences/shared_preferences.dart';

class BLAudio {
  SharedPreferences? pref;
  bool soundEffects;
  bool backgroundMusic;

  BLAudio({this.pref, required this.soundEffects, required this.backgroundMusic});
  // BLAudio copyWith({SharedPreferences? pref, bool? soundEffects, bool? backgroundMusic}) {
  //   return BLAudio(
  //       pref: pref,
  //       soundEffects: soundEffects ?? this.soundEffects,
  //       backgroundMusic: backgroundMusic ?? this.backgroundMusic);
  // }
}
