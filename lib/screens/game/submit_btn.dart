import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSubmitButton extends ConsumerWidget {
  const GameSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.read(gameManagerProvider.notifier);
    return BLButton(
        onPressed: () {
          gameManager.nextChallenge();
        },
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
