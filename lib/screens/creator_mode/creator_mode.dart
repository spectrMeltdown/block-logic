import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/dialog/help_dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreatorMode extends StatelessWidget {
  const CreatorMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BLBackButton(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const BLHelpDialog());
                    },
                    icon: const Icon(FontAwesomeIcons.circleQuestion))
              ],
            ),
          ),
          const Center(
            child: BLTitle('Creator Mode'),
          ),
        ],
      )),
    );
  }
}
