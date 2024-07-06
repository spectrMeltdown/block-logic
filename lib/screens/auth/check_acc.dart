import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/shared_pref.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckAcc extends ConsumerStatefulWidget {
  const CheckAcc({super.key});

  @override
  ConsumerState<CheckAcc> createState() => _CheckAccState();
}

class _CheckAccState extends ConsumerState<CheckAcc> {
  @override
  void initState() {
    FlameAudio.bgm.initialize();

    /// check if a backgroundMusic setting exists
    final backgroundMusic = SharedPreferencesHelper.instance.getBool('backgroundMusic');
    if (backgroundMusic == null || backgroundMusic == true) {
      /// initialize the audio
      FlameAudio.bgm.play(Assets.audioBG1);
    } else {
      /// play silently to load the track
      FlameAudio.bgm.play(Assets.audioBG1, volume: 0);

      /// pause after track loaded
      FlameAudio.bgm.pause();
    }
    super.initState();
  }

  Widget getWidget() {
    /// check if logged in
    if (AuthService.isLoggedIn()) {
      /// check if email is not verified
      if (!AuthService.isEmailVerified()) {
        /// go to email verification screen (after main menu finish building)
        return const VerifyEmail();
      } else {
        /// initialize user details in firestore
        AuthService.initAccountFirestore(context);
      }
    }
    return const MainMenuScreen();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountProvider);
    return user.when(
        data: (user) {
          return getWidget();
        },
        error: (error, stackTrace) => getWidget(),
        loading: () => getWidget());
  }
}
