import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/spaced_col.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/game/game_room.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:block_logic/screens/settings.dart';
import 'package:block_logic/screens/tutorials/tutorials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late Animation<double> _blurRadiusAnimation;
  final menuController = MenuController();
  late Assets assets;
  late final VideoPlayerController _controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground again
      _controller.play();
    } else {
      // App is in the background or inactive
      _controller.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
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
    _controller = VideoPlayerController.asset(assets.bg1,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
    _controller.setLooping(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountAuthProvider);
    final auth = ref.read(authServiceProvider.notifier);
    final nav = ref.watch(customNavigationProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Row(
              children: user.when(
                data: (user) {
                  if (user == null) {
                    return [const BlankWidget()];
                  } else {
                    return [
                      MenuAnchor(
                        controller: menuController,
                        style: const MenuStyle(alignment: Alignment(-1, 1.4)),
                        menuChildren: [
                          GestureDetector(
                            onTapDown: (TapDownDetails tap) => {
                              // TODO: add a overlay color
                            },
                            onTapUp: (details) {
                              auth.logout();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                  BLText('Logout', color: Colors.red)
                                ],
                              ),
                            ),
                          )
                        ],
                        child: BLProfilePic(
                          auth.getUID(),
                          onPressed: () {
                            if (menuController.isOpen) {
                              menuController.close();
                            } else {
                              menuController.open();
                            }
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: BLDisplayName(
                            auth.getUID(),
                          ))
                    ];
                  }
                },
                error: (error, stackTrace) => const [BLError()],
                loading: () => const [BLLoading()],
              ),
            ),
          ),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Shadow(
                                        blurRadius: _blurRadiusAnimation.value,
                                        color: Colors.white),
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
                                    Shadow(
                                        blurRadius: _blurRadiusAnimation.value,
                                        color: Colors.white),
                                  ],
                                ));
                          }),
                    )
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                SpacedColumn(
                    spacing: 10,
                    children: auth.isLoggedIn()
                        ? loggedInMenu(context, nav)
                        : loggedOutMenu(context, nav))
              ]))
        ]),
      ),
    );
  }
}

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
      onPressed: () => nav.push(context, const Tutorials()),
      child: const Text(
        'Tutorials',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(
          context,

          /// TODO: change back to creator mode later
          const GameRoom(
            roomID: 'testing',
          )),
      child: const Text(
        'Creator Mode',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => nav.push(context, const Settings()),
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

List<Widget> loggedOutMenu(BuildContext context, CustomNavigation nav) {
  return [
    BLButton(
      onPressed: () => nav.push(context, const Login()),
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
      onPressed: () => nav.push(context, const Settings()),
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
