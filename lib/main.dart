import 'dart:io';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/shared_pref.dart';
import 'package:block_logic/screens/auth/check_acc.dart';

import 'package:block_logic/splash.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

Future<void> main() async {
  /// Ensure the system overlays are set before running the app
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the device to fullScreen, hiding status bar & navigation buttons
  await Flame.device.fullScreen();

  /// Force device to default portrait mode only
  Flame.device.setPortraitUpOnly;
  await SharedPreferencesHelper.instance.init();
  // Hide the status bar
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  // re-hide the status bar after user opens it
  // SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
  //   await Future.delayed(const Duration(seconds: 1));
  //   SystemChrome.restoreSystemUIOverlays();
  // });

  if (Platform.isAndroid) {
    /// Setup Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
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
  // check if platform is web
  else if (kIsWeb) {}

  // TODO: use get_it package for create global singletons

  // setupServiceLocator();

  // cache assets for faster loading
  await FlameAudio.audioCache.loadAll([Assets.audioBG1]);

  runApp(const ProviderScope(child: BlockLogic()));
}

class BlockLogic extends StatelessWidget {
  const BlockLogic({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle appTextStyle = TextStyle(
      color: Colors.white,
    );

    /// Make the same text theme for both system dark/light theme
    const TextTheme appTextTheme = TextTheme(
      displayLarge: appTextStyle,
      displayMedium: appTextStyle,
      displaySmall: appTextStyle,
      headlineLarge: appTextStyle,
      headlineMedium: appTextStyle,
      headlineSmall: appTextStyle,
      titleLarge: appTextStyle,
      titleMedium: appTextStyle,
      titleSmall: appTextStyle,
      bodyLarge: appTextStyle,
      bodyMedium: appTextStyle,
      bodySmall: appTextStyle,
      labelLarge: appTextStyle,
      labelMedium: appTextStyle,
      labelSmall: appTextStyle,
    );

    /// Make the same app theme for system dark or light theme
    final appTheme = ThemeData(
      fontFamily: 'Play',
      textTheme: appTextTheme,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade400),
      scaffoldBackgroundColor: Colors.transparent,
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.black,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );

    /// toastificationWrapper is for displaying toasts without using context
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Block-Logic',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        darkTheme: appTheme,
        home: kDebugMode ? const CheckAcc() : const Splash(),
      ),
    );
  }
}
