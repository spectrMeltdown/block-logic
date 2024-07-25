import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameRunButton extends ConsumerWidget {
  const GameRunButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BLButton(
        type: BtnType.green,
        onPressed: () {},
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.circlePlay,
              size: 15,
            ),
            SizedBox(width: 5),
            BLText(
              'Run',
              size: 16,
              color: Colors.white,
            )
          ],
        ));
  }
}
