import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AboutUs extends ConsumerWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.read(assetsProvider);
    final nav = ref.read(customNavigationProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      WidgetAnimator(
                        incomingEffect: WidgetTransitionEffects.incomingScaleUp(delay: const Duration(milliseconds: 300)),
                        child: Image.asset(
                          assets.logo,
                          width: 250,
                          height: 250,
                        ),
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
                onPressed: () => nav.pop(context),
                type: BtnType.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: const BLText('Back'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
