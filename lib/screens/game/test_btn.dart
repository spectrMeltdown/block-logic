import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/screens/game/test_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameTestBtn extends ConsumerStatefulWidget {
  const GameTestBtn({super.key});

  @override
  ConsumerState<GameTestBtn> createState() => _GameRunButtonState();
}

class _GameRunButtonState extends ConsumerState<GameTestBtn> {
  bool processing = false;
  late final GameManager manager;

  @override
  void initState() {
    manager = ref.read(gameManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final errorCount = ref.watch(gameManagerProvider.select((state) => state.errorCount));
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [BLText('Error Count: \n${errorCount == -1 ? '--' : errorCount.toString()}')],
    // );
    return BLButton(
        onPressed: () async {
          if (processing) return;
          processing = true;
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const TestDialog(),
          );
          processing = false;
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.flask,
              size: 18,
            ),
            SizedBox(width: 5),
            BLText(
              'Test',
              color: Colors.white,
            )
          ],
        ));
  }
}
