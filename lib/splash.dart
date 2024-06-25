import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash> {
  // Adding the controller breaks the splash screen for some reason (stuck on loading)

  // final FlameSplashController controller = FlameSplashController(
  //   fadeInDuration: const Duration(seconds: 1),
  //   fadeOutDuration: const Duration(milliseconds: 250),
  //   waitDuration: const Duration(seconds: 1),
  //   autoStart: false,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FlameSplashScreen(
        showBefore: (BuildContext context) {
          return const BLTitle("Uncaught Exception");
        },
        theme: FlameSplashTheme(
            backgroundDecoration:
                const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.backgroundNoGrid))),
            logoBuilder: (context) => Image.asset(
                  Assets.logo,
                  fit: BoxFit.cover,
                )),
        onFinish: (context) => Utils.pushReplace(context, const MainMenuScreen()),
      ),
    );
  }
}
