import 'dart:io';

import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/screens/auth/check_acc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

Future<void> main() async {
  /// Ensure the system overlays are set before running the app
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the device to fullScreen, hiding status bar & navigation buttons
  //await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  Flame.device.fullScreen();
  Flame.device.setPortraitUpOnly;
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
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPrefProvider.overrideWithValue(prefs),
  ], child: const BlockLogic()));
}

class BlockLogic extends ConsumerWidget {
  const BlockLogic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(audioInitProvider);
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
      tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.blueGrey.shade800,
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
          home:
              // const GameRoom(
              //     roomID: 'offline-testing',
              //   )
              const CheckAcc()
          //const Splash(),
          ),
    );
  }
}
