import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/game_provider.dart';
import 'package:block_logic/logic/services/toast.dart';
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
  late final Toast toast;

  @override
  void initState() {
    manager = ref.read(gameManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final errorCount = ref.watch(gameManagerProvider.select((state) => state.errorCount));
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [BLText('Error Count: \n${errorCount == -1 ? '--' : errorCount.toString()}')],
    // );
    final hasBlocks = ref.watch(getRootDataProvider).isNotEmpty;
    return BLButton(
        type: hasBlocks ? BtnType.normal : BtnType.grey,
        onPressed: () async {
          if (!hasBlocks) {
            toast.showToast('Place a block first.', type: NotifType.error);
            return;
          }
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
