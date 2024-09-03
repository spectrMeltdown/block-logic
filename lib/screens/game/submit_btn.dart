import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSubmitButton extends ConsumerWidget {
  final void Function() updateChallenge;
  const GameSubmitButton(this.updateChallenge, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BLButton(
        onPressed: () => updateChallenge(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch_outlined,
              size: 15,
            ),
            SizedBox(width: 5),
            BLText(
              'Submit',
              size: 16,
              color: Colors.white,
            )
          ],
        ));
  }
}
