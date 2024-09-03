import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/util/spaced_col.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/creator_mode/creator_mode.dart';
import 'package:block_logic/screens/feedback/feedback_dialog.dart';
import 'package:block_logic/screens/leaderboard/leaderboards_page.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:block_logic/screens/settings/settings_page.dart';
import 'package:block_logic/screens/tutorials/tutorials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Widget> loggedInMenu(BuildContext context, CustomNavigation nav) {
  return [
    BLButton(
      onPressed: () => nav.push(context, const RoomSelector()),
      type: BtnType.green,
      child: const Text(
        'Start',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(context, const LeaderboardsPage()),
      child: const Text(
        'Leaderboards',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(context, const Tutorials()),
      child: const Text(
        'Tutorials',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(
        context,
        const CreatorMode(),
      ),
      child: const Text(
        'Creator Mode',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(context, const SettingsPage()),
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 16),
      ),
    ),
    const SizedBox(
      height: 30,
    ),
    BLButton(
      onPressed: () {
        SystemNavigator.pop();

        /// exit(0) works for development, but the above is preferred
        if (kDebugMode) exit(0);
      },
      type: BtnType.red,
      child: const Text(
        'Exit',
        style: TextStyle(fontSize: 16),
      ),
    ),
    const SizedBox(
      height: 80,
    ),
  ];
}

List<Widget> loggedOutMenu(BuildContext context, CustomNavigation nav) {
  return [
    BLButton(
      onPressed: () => nav.push(
          context,
          const Login(
            accountType: FirestoreCollections.users,
          )),
      type: BtnType.green,
      child: const Text(
        'Login to Play',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(context, const Tutorials()),
      child: const Text(
        'Tutorials',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(context, const SettingsPage()),
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 16),
      ),
    ),
    const SizedBox(
      height: 30,
    ),
    BLButton(
      onPressed: () {
        SystemNavigator.pop();

        /// exit(0) works for development, but the above is preferred
        if (kDebugMode) exit(0);
      },
      type: BtnType.red,
      child: const Text(
        'Exit',
        style: TextStyle(fontSize: 16),
      ),
    ),
    const SizedBox(
      height: 80,
    )
  ];
}

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _titleAnimationController;
  late final Animation<double> _blurRadiusAnimation;
  final menuController = MenuController();
  late Assets assets;
  late Toast toast;
  //late final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final nav = ref.read(customNavigationProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: FloatingActionButton(
            onPressed: () async {
              await showDialog(context: context, builder: (context) => const FeedbackDialog());
            },
            child: const Icon(FontAwesomeIcons.message)),
      ),
      body: Background(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SlideInLeft(
                      duration: const Duration(milliseconds: 1000),
                      child: AnimatedBuilder(
                          animation: _titleAnimationController,
                          builder: (context, child) {
                            return Text('BLOCK',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MajorMonoDisplay',
                                  fontSize: 60,
                                  height: 1.05,
                                  shadows: <Shadow>[
                                    Shadow(blurRadius: _blurRadiusAnimation.value, color: Colors.white),
                                  ],
                                ));
                          }),
                    ),
                    SlideInRight(
                      duration: const Duration(milliseconds: 1300),
                      child: AnimatedBuilder(
                          animation: _titleAnimationController,
                          builder: (context, child) {
                            return Text('LOGIC',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MajorMonoDisplay',
                                  fontSize: 60,
                                  height: 1.05,
                                  shadows: <Shadow>[
                                    Shadow(blurRadius: _blurRadiusAnimation.value, color: Colors.white),
                                  ],
                                ));
                          }),
                    )
                  ],
                ),
                SpacedColumn(spacing: 10, children: [
                  ...auth.isLoggedIn() ? loggedInMenu(context, nav) : loggedOutMenu(context, nav),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // App is in the foreground again
  //     _controller.play();
  //   } else {
  //     // App is in the background or inactive
  //     _controller.pause();
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    toast.dismissAllToast();
    super.didPop();
  }

  @override
  void didPushNext() {
    toast.dismissAllToast();
    super.didPushNext();
  }

  @override
  void dispose() {
    toast.dismissAllToast();
    _titleAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    assets = ref.read(assetsProvider);

    /// for the entire title
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true, period: const Duration(milliseconds: 2000));

    /// for blur property of the title
    _blurRadiusAnimation = Tween<double>(
      begin: 0,
      end: 100,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    ));

    /// video bg
    // _controller = VideoPlayerController.asset(assets.bg1,
    //     videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
    //   ..initialize().then((_) {
    //     _controller.play();
    //     setState(() {});
    //   });
    //_controller.setLooping(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
}
