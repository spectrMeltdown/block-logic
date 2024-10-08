import 'dart:async';

import 'package:block_logic/app_theme.dart';

import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/router_config.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:block_logic/test_game.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate();
    // await initializeService();
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
    overrides: [
      sharedPrefProvider.overrideWithValue(prefs),
    ],
    child: const BlockLogic(),
  ));
}

class BlockLogic extends StatelessWidget {
  const BlockLogic({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();
    if (!kIsWeb) {
      //ref.watch(internetStatusProvider);
      return MaterialApp(
        title: 'Block-Logic',
        debugShowCheckedModeBanner: false,
        // navigatorObservers: [routeObserver],
        theme: appTheme.theme(),
        darkTheme: appTheme.theme(),
        // home: const Checkpoint(),
        home: const TestGame(),
      );
    }
    return MaterialApp.router(
      // builder: (context, child) => ResponsiveBreakpoints.builder(
      //   child: child!,
      //   breakpoints: [
      //     const Breakpoint(start: 0, end: 450, name: MOBILE),
      //     const Breakpoint(start: 451, end: 800, name: TABLET),
      //     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
      //     const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      //   ],
      // ),
      title: 'Block-Logic',
      debugShowCheckedModeBanner: false,
      builder: FToastBuilder(),
      routerConfig: router(),
      theme: appTheme.theme(),
      darkTheme: appTheme.theme(),
    );
  }
}

// Initialize the background service
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: closeAppService, // function to run
//       isForegroundMode: true, // persistent notification (for debug)
//       autoStart: true, // Start automatically when the app goes to the background
//     ),
//     iosConfiguration: IosConfiguration(
//       onForeground: closeAppService,
//       autoStart: false,
//     ),
//   );

//   service.startService();
// }
