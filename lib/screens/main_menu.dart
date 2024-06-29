import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:block_logic/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenuScreen extends ConsumerStatefulWidget {
  const MainMenuScreen({super.key});

  @override
  ConsumerState<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends ConsumerState<MainMenuScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late Animation<double> _blurRadiusAnimation;
  final user = StreamProvider<User?>((ref) {
    return FirebaseAuth.instance.authStateChanges();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _blurRadiusAnimation = Tween<double>(
      begin: 2,
      end: 50,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    ));
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(Assets.audioBG1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: FadeInUp(
          from: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Consumer<User?>(
                  builder: (context, user, child) {
                    if (user == null) {
                      return Row(
                        children: [
                          BLProfilePic(
                            onPressed: () {
                              Utils.push(context, const Settings());
                            },
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          BLProfilePic(
                            onPressed: () {
                              Utils.push(context, const Settings());
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: BLText(
                              user.displayName ?? '',
                              size: 20,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: AnimatedBuilder(
                  animation: _titleAnimationController,
                  builder: (context, child) {
                    return Text(
                      'BLOCK\nLOGIC',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.majorMonoDisplay(
                        fontSize: 60,
                        height: 1.05,
                        shadows: <Shadow>[
                          Shadow(blurRadius: _blurRadiusAnimation.value, color: Colors.white),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: [
                  BLButton(
                    onPressed: () => Utils.push(context, Rooms()),
                    type: BtnType.green,
                    child: const Text(
                      'Start',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  BLButton(
                    onPressed: () {},
                    child: const Text(
                      'Tutorials',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  BLButton(
                    onPressed: () {},
                    child: const Text(
                      'Creator Mode',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  BLButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings())),
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
