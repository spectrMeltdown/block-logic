import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/login_check.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/screens/auth/duplicate_login.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/screens/main_menu.dart';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Checkpoint extends ConsumerWidget {
  const Checkpoint({super.key});

  @override
  Widget build(BuildContext context, ref) {
    const Widget errorWidget = Scaffold(
      body: Background(
        child: BLError(),
      ),
    );
    const Widget loadingWidget = Scaffold(
      body: Background(
        child: BLLoading(
          message: 'Loading Game...',
        ),
      ),
    );
    final auth = ref.read(authServiceProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final assets = ref.read(assetsProvider);
    ref.read(audioInitProvider);
    FlameAudio.bgm.initialize();

    /// check if a backgroundMusic setting exists
    final backgroundMusic = sharedPref.getBool('backgroundMusic');
    if (backgroundMusic == null || backgroundMusic == true) {
      /// initialize the audio
      FlameAudio.bgm.play(assets.audioBG1);
    } else {
      /// play silently to load the track
      FlameAudio.bgm.play(assets.audioBG1, volume: 0);

      /// pause after track loaded
      FlameAudio.bgm.pause();
    }
    final user = ref.watch(authChangesProvider);
    return user.when(
      data: (user) {
        final accountService = ref.read(accountServiceProvider.notifier);

        /// check if logged in
        if (auth.isLoggedIn()) {
          final dupLoginCheck = ref.watch(loginCheckProvider);
          return dupLoginCheck.when(
            data: (sessionID) {
              // debugPrint(sessionID);
              if (sessionID != null && sessionID.isNotEmpty) {
                // debugPrint(sessionID);
                if (sessionID != sharedPref.getString('sessionID')) {
                  return const DuplicateLogin();
                }
              }

              /// check if email is not verified
              if (auth.getEmail().isNotEmpty && !auth.isEmailVerified()) {
                /// go to email verification screen (after main menu finish building)
                return const VerifyEmail();
              }

              final userFirestore = ref.watch(SelectedUserProvider(auth.getUID()));

              /// check if user is initialized in firestore
              return userFirestore.when(
                data: (userAccount) {
                  /// if not initialized
                  if (userAccount == null) {
                    // debugPrint('account not initialized');

                    /// initialize user details in firestore
                    accountService.initFirestoreData(type: AccountType.user);
                  }
                  return const MainMenuScreen();
                },
                error: (error, stackTrace) {
                  genericError(error, stackTrace);
                  return errorWidget;
                },
                loading: () {
                  // debugPrint('Loading in checkpoint');
                  genericLoading();
                  return loadingWidget;
                },
              );
            },
            error: (error, stackTrace) {
              genericError(error, stackTrace);
              return errorWidget;
            },
            loading: () {
              // debugPrint('Loading in checkpoint');
              genericLoading();
              return loadingWidget;
            },
          );
        }
        return const MainMenuScreen();
      },
      error: (error, stackTrace) {
        genericError(error, stackTrace);
        return errorWidget;
      },
      loading: () {
        // debugPrint('Loading in checkpoint');
        genericLoading();
        return loadingWidget;
      },
    );
  }
}
