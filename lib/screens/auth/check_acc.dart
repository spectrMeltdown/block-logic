import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/providers/providers.dart';
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
    FlameAudio.bgm.play(Assets.audioBG1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountProvider);
    return user.when(
        data: (user) {
          debugPrint(AuthService.isEmailVerified().toString());

          /// check if logged in
          if (AuthService.isLoggedIn()) {
            /// check if email is not verified
            if (!AuthService.isEmailVerified()) {
              /// go to email verification screen (after main menu finish building)
              return const VerifyEmail();
            }
          }
          return const MainMenuScreen();
        },
        error: blankError,
        loading: blankLoading);
  }
}
