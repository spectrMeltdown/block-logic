import 'dart:async';

import 'package:block_logic/app_theme.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/firebase_providers/selected_admin.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/router_config.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  if (!kIsWeb) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );
    // FlutterError.onError = (errorDetails) {
    //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPrefProvider.overrideWithValue(prefs)],
    child: const BlockLogic(),
  ));
}

class BlockLogic extends ConsumerWidget {
  const BlockLogic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme();
    if (!kIsWeb) {
      ref.read(audioInitProvider);
      //ref.watch(internetStatusProvider);
      return ToastificationWrapper(
        child: MaterialApp(
          title: 'Block-Logic',
          navigatorObservers: [routeObserver],
          debugShowCheckedModeBanner: false,
          theme: appTheme.theme(),
          darkTheme: appTheme.theme(),
          //home: const Checkpoint(),
          home: Scaffold(
              body: Background(
            child:
                GameChallenge(updateChallenge: () {}, roomName: 'Testing', challenge: Challenge(), challengeCount: 1),
          )),
        ),
      );
    }
    ref.watch(authChangesProvider);
    Future<String?> redirect() async {
      final auth = ref.read(authServiceProvider.notifier);
      //if (user.isLoading || user.hasError) return '/loading';
      if (FirebaseAuth.instance.currentUser != null) {
        if (FirebaseAuth.instance.currentUser?.emailVerified == null ||
            FirebaseAuth.instance.currentUser!.emailVerified == false) {
          /// go to email verification screen (after main menu finish building)
          return '/verify-email';
        }

        final adminFirestore = await ref.watch(SelectedAdminProvider(auth.getUID()).future);
        if (adminFirestore == null) {
          return '/unauthorized';
        }
        if (adminFirestore.verificationID != null && adminFirestore.verificationID!.isEmpty) {
          return '/verify-phone-num';
        }
        return null;
      } else {
        return '/login';
      }
    }

    return ToastificationWrapper(
      child: MaterialApp.router(
        // builder: (context, child) => ResponsiveBreakpoints.builder(
        //   child: child!,
        //   breakpoints: [
        //     const Breakpoint(start: 0, end: 450, name: MOBILE),
        //     const Breakpoint(start: 451, end: 800, name: TABLET),
        //     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        //     const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        //   ],
        // ),
        builder: FToastBuilder(),
        routerConfig: router(redirect()),
        title: 'Block-Logic',
        debugShowCheckedModeBanner: false,
        theme: appTheme.theme(),
        darkTheme: appTheme.theme(),
      ),
    );
  }
}
