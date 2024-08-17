import 'dart:async';

import 'package:block_logic/app_theme.dart';
import 'package:block_logic/logic/firebase_providers/selected_admin.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/internet_connection.dart';
import 'package:block_logic/logic/services/redirect.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/router_config.dart';
import 'package:block_logic/screens/init_android.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      ref.watch(internetStatusProvider);
      return ToastificationWrapper(
        child: MaterialApp(
            title: 'Block-Logic',
            navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
            theme: appTheme.theme(),
            darkTheme: appTheme.theme(),
            home: const InitAndroid()),
      );
    }

    final auth = ref.read(authServiceProvider.notifier);
    final adminFirestore = ref.watch(SelectedAdminProvider(auth.getUID()));
    final redirect = ref.watch(RedirectProvider(adminFirestore, auth));
    return ToastificationWrapper(
      child: MaterialApp.router(
        routerConfig: router(redirect),
        title: 'Block-Logic',
        debugShowCheckedModeBanner: false,
        theme: appTheme.theme(),
        darkTheme: appTheme.theme(),
      ),
    );
  }
}
