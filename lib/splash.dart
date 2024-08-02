import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/screens/auth/check_acc.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _Splash();
}

class _Splash extends ConsumerState<Splash> {
  // Adding the controller breaks the splash screen for some reason (stuck on loading)

  // final FlameSplashController controller = FlameSplashController(
  //   fadeInDuration: const Duration(seconds: 1),
  //   fadeOutDuration: const Duration(milliseconds: 250),
  //   waitDuration: const Duration(seconds: 1),
  //   autoStart: false,
  // );

  @override
  Widget build(BuildContext context) {
    final assets = ref.read(assetsProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FlameSplashScreen(
          showBefore: (BuildContext context) {
            return const BLTitle('Uncaught Exception');
          },
          theme: FlameSplashTheme(
              backgroundDecoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(assets.backgroundNoGrid))),
              logoBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(80),
                    child: Image.asset(
                      assets.logo,
                      fit: BoxFit.cover,
                    ),
                  )),
          onFinish: (context) => const CheckAcc()),
    );
  }
}
