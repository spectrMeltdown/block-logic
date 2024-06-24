import 'dart:io';
import 'package:block_logic/game/assets.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Ensure the system overlays are set before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Hide the status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

  // re-hide the status bar after user opens it
  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    await Future.delayed(const Duration(seconds: 1));
    SystemChrome.restoreSystemUIOverlays();
  });

  // check if platform is android
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  // check if platform is web
  else if (kIsWeb) {}
  // use getit later
  // setupServiceLocator();
  // cache tasks
  await FlameAudio.audioCache.loadAll([Assets.audioBG1]);
  runApp(const BlockLogic());
}

class BlockLogic extends StatelessWidget {
  const BlockLogic({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Block-Logic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: GoogleFonts.playTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.majorMonoDisplay(
              textStyle: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          )),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const MainMenuScreen(),
    );
  }
}
