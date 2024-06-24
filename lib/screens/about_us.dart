import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/game/assets.dart';
import 'package:block_logic/game/utils.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(
            children: [BLBackButton()],
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [BLTitle('About Us')],
            ),
          ),
          BLPanel(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 35),
              child: Column(
                children: [
                  Image.asset(
                    Assets.logo,
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  BLText(
                    'Hey programmer!',
                    color: Colors.white,
                    size: 20,
                  ),
                  BLText(
                    'Hope you loved our game!',
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  BLText('Made by:'),
                  BLSmallTitle('Uncaught Exception', color: Colors.lightBlue[100]),
                  BLText(
                    'A Capstone Project \nfrom USTP Oroquieta',
                    alignCenter: true,
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          BLButton(
            onPressed: () => Utils.pop(context),
            type: BtnType.red,
            child: BLText('Back'),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          )
        ],
      )),
    );
  }
}
