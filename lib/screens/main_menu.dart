import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/game/assets.dart';
import 'package:block_logic/game/utils.dart';
import 'package:block_logic/screens/settings.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(Assets.audioBG1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  BLProfilePic(),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: BLText(
                      'Guest',
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Text(
                'BLOCK\nLOGIC',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 60, height: 1.05),
              ),
            ),
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                BLButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
    );
  }
}
