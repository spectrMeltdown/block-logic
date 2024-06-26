import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/utils.dart';
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
          const Row(
            children: [BLBackButton()],
          ),
          const Padding(
            padding: EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [BLTitle('About Us')],
            ),
          ),
          BLPanel(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
              child: Column(
                children: [
                  Image.asset(
                    Assets.logo,
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const BLText(
                    'Hey programmer!',
                    color: Colors.white,
                    size: 20,
                  ),
                  const BLText(
                    'Hope you loved our game!',
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const BLText('Made by:'),
                  BLSmallTitle('Uncaught Exception', color: Colors.lightBlue[100]),
                  const BLText(
                    'A Capstone Project \nfrom USTP Oroquieta',
                    alignCenter: true,
                  ),
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          BLButton(
            onPressed: () => Utils.pop(context),
            type: BtnType.red,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: const BLText('Back'),
          )
        ],
      )),
    );
  }
}
