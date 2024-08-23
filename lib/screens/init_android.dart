import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitAndroid extends ConsumerStatefulWidget {
  const InitAndroid({super.key});

  @override
  ConsumerState<InitAndroid> createState() => _InitAndroidState();
}

class _InitAndroidState extends ConsumerState<InitAndroid> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final user = ref.watch(accountAuthProvider);
    final dbService = ref.watch(dBServiceProvider.notifier);
    final userFirestore = ref.watch(SelectedUserProvider(auth.getUID()));
    return user.when(
        data: (user) => getWidget(
            auth: auth, userFirestore: userFirestore, dbService: dbService),
        error: (error, stackTrace) => getWidget(
            auth: auth, userFirestore: userFirestore, dbService: dbService),
        loading: () => getWidget(
            auth: auth, userFirestore: userFirestore, dbService: dbService));
  }

  Widget getWidget({
    required AuthService auth,
    required AsyncValue<UserAccount?> userFirestore,
    required DBService dbService,
  }) {
    /// check if logged in
    if (auth.isLoggedIn()) {
      /// check if email is not verified
      if (!auth.isEmailVerified()) {
        /// go to email verification screen (after main menu finish building)
        return const VerifyEmail();
      }

      /// TODO: check if phone number was verified

      else {
        /// check if user is initialized in firestore
        userFirestore.when(
            data: (userAccount) {
              /// if not initialized
              if (userAccount == null) {
                debugPrint('account not initialized');

                /// initialize user details in firestore
                dbService.initAccountFirestore();
              }
            },
            error: genericError,
            loading: genericLoading);
      }
    }
    return const MainMenuScreen();
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
