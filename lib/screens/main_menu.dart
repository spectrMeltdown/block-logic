import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/account_details.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/loading.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/toast.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/creator_mode/creator_mode.dart';
import 'package:block_logic/screens/game/room_selector.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:block_logic/screens/settings.dart';
import 'package:block_logic/screens/tutorials/tutorials.dart';
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
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true, period: const Duration(milliseconds: 2000));
    _blurRadiusAnimation = Tween<double>(
      begin: 2,
      end: 50,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    ));
    _controller =
        VideoPlayerController.asset(Assets.bg1, videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
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
    final user = ref.watch(accountProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        controller: _controller,
        asset: Assets.bg1,
        child: FadeInUp(
          from: 25,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    children: user.when(
                      data: (user) {
                        if (user == null) {
                          return [blankWidget];
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
                                    AuthService.logout(context);
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
                                onPressed: () {
                                  if (menuController.isOpen) {
                                    menuController.close();
                                  } else {
                                    menuController.open();
                                  }
                                },
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10), child: BLDisplayName())
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
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: _titleAnimationController,
                          builder: (context, child) {
                            return Text('BLOCK\nLOGIC',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MajorMonoDisplay',
                                  fontSize: 60,
                                  height: 1.05,
                                  shadows: <Shadow>[
                                    Shadow(blurRadius: _blurRadiusAnimation.value, color: Colors.white),
                                  ],
                                ));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      SpacedColumn(
                          spacing: 10,
                          children: AuthService.isLoggedIn() ? loggedInMenu(context) : loggedOutMenu(context))
                    ]))
              ]),
        ),
      ),
    );
  }
}

List<Widget> loggedInMenu(BuildContext context) {
  return [
    BLButton(
      onPressed: () => Utils.push(context, const RoomSelector()),
      type: BtnType.green,
      child: const Text(
        'Start',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => Utils.push(context, const Tutorials()),
      child: const Text(
        'Tutorials',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => Utils.push(context, const CreatorMode()),
      child: const Text(
        'Creator Mode',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => Utils.push(context, const Settings()),
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
        Utils.assertFunc(() => exit(0));
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

List<Widget> loggedOutMenu(BuildContext context) {
  return [
    BLButton(
      onPressed: () => Utils.push(context, const Login()),
      type: BtnType.green,
      child: const Text(
        'Login to Play',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => Utils.push(context, const Tutorials()),
      child: const Text(
        'Tutorials',
        style: TextStyle(fontSize: 16),
      ),
    ),
    BLButton(
      onPressed: () => Utils.push(context, const Settings()),
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
        Utils.assertFunc(() => exit(0));
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
