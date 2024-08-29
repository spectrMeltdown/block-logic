import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Checkpoint extends ConsumerStatefulWidget {
  const Checkpoint({super.key});

  @override
  ConsumerState<Checkpoint> createState() => _CheckpointState();
}

class _CheckpointState extends ConsumerState<Checkpoint> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final user = ref.watch(authChangesProvider);
    final accountService = ref.read(accountServiceProvider.notifier);
    final userFirestore = ref.watch(SelectedUserProvider(auth.getUID()));
    return user.when(
      data: (user) {
        /// check if logged in
        if (auth.isLoggedIn()) {
          /// check if email is not verified
          if (!auth.isEmailVerified()) {
            /// go to email verification screen (after main menu finish building)
            return const VerifyEmail();
          }

          /// check if user is initialized in firestore
          return userFirestore.when(
              data: (userAccount) {
                /// if not initialized
                if (userAccount == null) {
                  debugPrint('account not initialized');

                  /// initialize user details in firestore
                  accountService.initFirestoreData();
                }

                // TODO: disabled because unclear what SMS is for
                // if (userAccount?.verificationID != null) {
                //   return const VerifyPhoneNum();
                // }
                return const MainMenuScreen();
              },
              error: genericError,
              loading: () {
                debugPrint('Loading in checkpoint');
                return genericLoading();
              });
        }
        return const MainMenuScreen();
      },
      error: genericError,
      loading: () {
        debugPrint('Loading in checkpoint');
        return genericLoading();
      },
    );
  }

  @override
  void initState() {
    final sharedPref = ref.read(sharedPrefProvider);
    final assets = ref.read(assetsProvider);
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
    super.initState();
  }
}
