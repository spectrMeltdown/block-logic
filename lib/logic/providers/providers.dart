import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/audio.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/models.dart';
import 'package:block_logic/logic/persistent_data.dart';
import 'package:block_logic/logic/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// @Riverpod()
// Stream<SharedPreferences> sharedPreferencesStream(SharedPreferencesStreamRef ref) async* {
//   final StreamController<SharedPreferences> controller = StreamController<SharedPreferences>();

//   final sharedPreferences = await SharedPreferences.getInstance();

//   controller.add(sharedPreferences);

//   Timer.periodic(Duration(seconds: 1), (timer) async {
//     final updatedSharedPreferences = await SharedPreferences.getInstance();
//     controller.add(updatedSharedPreferences);
//   });

//   yield* controller.stream;

//   ref.onDispose(() {
//     controller.close();
//   });
// }

@Riverpod(keepAlive: true)
class PersistentDataState extends _$PersistentDataState {
  @override
  PersistentData build() {
    debugPrint('PersistentDataState built');
    final notifications = SharedPreferencesHelper.instance.getBool('notifications') ?? true;
    return PersistentData(notifications: notifications);
  }

  void toggleNotifications() {
    /// negate current state
    state.notifications = !state.notifications;

    /// update in storage
    SharedPreferencesHelper.instance.setBool('notifications', state.notifications);
  }
}

@Riverpod(keepAlive: true)
class GameAudio extends _$GameAudio {
  @override
  BLAudio build() {
    debugPrint('GameAudio built');
    final soundEffects = SharedPreferencesHelper.instance.getBool('soundEffects') ?? true;
    final backgroundMusic = SharedPreferencesHelper.instance.getBool('backgroundMusic') ?? true;
    return BLAudio(soundEffects: soundEffects, backgroundMusic: backgroundMusic);
  }

  void playBtn() {
    debugPrint('playBtn');
    if (state.soundEffects == true) FlameAudio.play(Assets.btn1);
  }

  void toggleSoundEffects() {
    debugPrint('toggleSoundEffects');

    /// toggle the sound effects
    state.soundEffects = !state.soundEffects;

    /// save the user preference
    //state.pref?.setBool('soundEffects', state.soundEffects);
    debugPrint('sound effects is ${state.soundEffects} from toggle');
    SharedPreferencesHelper.instance.setBool('soundEffects', state.soundEffects);
    debugPrint('sound effects is ${SharedPreferencesHelper.instance.getBool('soundEffects')} from sharedPrefs');
  }

  void toggleBG() {
    debugPrint('toggleBG');

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
        FlameAudio.bgm.play(Assets.audioBG1);
      }
    } else {
      /// pause the audio
      FlameAudio.bgm.pause();
    }

    /// save the new value
    //state.pref?.setBool('backgroundMusic', state.backgroundMusic);
    debugPrint('backgroundMusic is ${state.backgroundMusic} from toggle');
    SharedPreferencesHelper.instance.setBool('backgroundMusic', state.backgroundMusic);
    debugPrint('backgroundMusic is ${SharedPreferencesHelper.instance.getBool('backgroundMusic')} from sharedPrefs');
  }
}

@Riverpod(keepAlive: true)
Stream<User?> account(AccountRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@Riverpod(keepAlive: true)
Stream<User?> accountChanges(AccountChangesRef ref) {
  return FirebaseAuth.instance.userChanges();
}

@Riverpod(keepAlive: true)
Stream<String?> accountPhotoURL(AccountPhotoURLRef ref) async* {
  final accountChanges = ref.watch(accountChangesProvider);
  final photoURL = accountChanges.value?.photoURL;
  yield photoURL;
}

// @Riverpod()
// String? accountPhotoURL(AccountPhotoURLRef ref) {
//   return FirebaseAuth.instance.currentUser?.photoURL;
// }

@Riverpod(keepAlive: true)
Stream<UserDetails?> userDetails(UserDetailsRef ref) {
  return DBService().streamUser(AuthService.getUID());
}

@Riverpod(keepAlive: true)
Stream<AccountSettings?> userSettings(UserSettingsRef ref) {
  return DBService().streamSettings(AuthService.getUID(), FirestoreCollections.users);
}

@Riverpod(keepAlive: true)
Stream<AccountSettings?> adminSettings(AdminSettingsRef ref) {
  return DBService().streamSettings(AuthService.getUID(), FirestoreCollections.admins);
}

@Riverpod(keepAlive: true)
Stream<AdminDetails?> adminDetails(AdminDetailsRef ref) {
  return DBService().streamAdmin(AuthService.getUID());
}
