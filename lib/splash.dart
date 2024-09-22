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
    // final assets = ref.read(assetsProvider);
    return const Placeholder();
  }
}
