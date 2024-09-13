import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRunButton extends ConsumerStatefulWidget {
  const GameRunButton({super.key});

  @override
  ConsumerState<GameRunButton> createState() => _GameRunButtonState();
}

class _GameRunButtonState extends ConsumerState<GameRunButton> {
  @override
  Widget build(BuildContext context) {
    final errorCount = ref.watch(gameManagerProvider.select((state) => state.errorCount));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [BLText('Error Count: \n${errorCount == -1 ? '--' : errorCount.toString()}')],
    );
  }
}
