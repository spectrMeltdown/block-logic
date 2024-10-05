import 'dart:async';

import 'package:block_logic/app_theme.dart';
import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/block_data_manager.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/router_config.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
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
    // if (kDebugMode) {
    //   await FirebaseAppCheck.instance.activate);
    // } else {

    // }
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

class BlockLogic extends ConsumerStatefulWidget {
  const BlockLogic({super.key});

  @override
  ConsumerState<BlockLogic> createState() => _BlockLogicState();
}

class _BlockLogicState extends ConsumerState<BlockLogic> {
  int currentChallenge = 0;
  void updateChallenge() {
    setState(() {
      currentChallenge++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final processing = ref.watch(processingProvider);
    final appTheme = AppTheme();
    if (!kIsWeb) {
      ref.read(audioInitProvider);
      //ref.watch(internetStatusProvider);
      return MaterialApp(
        title: 'Block-Logic',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        theme: appTheme.theme(),
        darkTheme: appTheme.theme(),
        // home: Login(accountType: FirestoreCollections.users),
        // home: const Checkpoint(),
        // home: Scaffold(
        //   body: Stack(
        //     fit: StackFit.expand,
        //     children: [
        //       Background(
        //         child: SafeArea(
        //           child: GameChallenge(
        //             currentChallenge: 1,
        //             roomName: 'Testing',
        //             challenge: Challenge(
        //               name: 'Testing 1',
        //               shortDescription: 'Testing 1',
        //               solutionMatch: ['Hello, World!'],
        //               blocks: AllBlocks().helloWorld(),
        //             ),
        //             challengeCount: 2,
        //             practiceMode: true,
        //           ),
        //         ),
        //       ),
        //       Visibility(
        //           visible: processing,
        //           child: Container(
        //             color: Colors.black.withOpacity(0.7),
        //             child: const BLLoading(
        //               message: 'Processing...',
        //             ),
        //           ))
        //     ],
        //   ),
        // ),
        home: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Background(
                child: SafeArea(
                  child: GameChallenge(
                    updateChallenge: updateChallenge,
                    currentChallenge: currentChallenge,
                    roomName: 'Testing',
                    challenge: Challenge(
                      name: currentChallenge == 0 ? 'Testing 1' : 'Testing 2',
                      shortDescription: currentChallenge == 0 ? 'Testing 1' : 'Testing 2',
                      solutionMatch: currentChallenge == 0 ? ['Hello, World!'] : ['Python is Awesome!'],
                      blocks: currentChallenge == 0 ? AllBlocks().helloWorld() : AllBlocks().pythonIsAwesome(),
                    ),
                    challengeCount: 2,
                    // practiceMode: true,
                  ),
                ),
              ),
              Visibility(
                  visible: processing,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const BLLoading(
                      message: 'Processing...',
                    ),
                  ))
            ],
          ),
        ),
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
