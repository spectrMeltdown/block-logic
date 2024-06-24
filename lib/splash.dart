import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreenGameState extends State<SplashScreenGame> {
  FlameSplashController controller;
  @override
  void initState() {
    super.initState();
    controller = FlameSplashController(
      fadeInDuration: Duration(seconds: 1),
      fadeOutDuration: Duration(milliseconds: 250),
      waitDuration: Duration(seconds: 2),
      autoStart: false,
    );
  }

  @override
  void dispose() {
    controller.dispose(); // dispose it when necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showBefore: (BuildContext context) {
          return Text("Before the logo");
        },
        showAfter: (BuildContext context) {
          return Text("After the logo");
        },
        theme: FlameSplashTheme.white,
        onFinish: (context) => Navigator.pushNamed(context, '/the-game-initial-screen'),
        controller: controller,
      ),
    );
  }
}
