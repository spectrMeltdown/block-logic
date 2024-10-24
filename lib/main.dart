import 'dart:async';

import 'package:block_logic/app_theme.dart';
import 'package:block_logic/logic/services/audio.dart';

import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/router_config.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );
  } else {
    usePathUrlStrategy();
  }
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPrefProvider.overrideWithValue(prefs),
    ],
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
      FlameAudio.bgm.initialize();
      //ref.watch(internetStatusProvider);
      return MaterialApp(
        title: 'Block-Logic',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        theme: appTheme.theme(),
        darkTheme: appTheme.theme(),
        home: const Checkpoint(),
        // home: const TestGame(),
      );
    }

    return MaterialApp.router(
      title: 'Block-Logic',
      debugShowCheckedModeBanner: false,
      builder: FToastBuilder(),
      routerConfig: router(),
      theme: appTheme.theme(),
      darkTheme: appTheme.theme(),
    );
  }
}
