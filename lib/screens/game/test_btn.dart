import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/logic/game/logic/time_box.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/test_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameTestBtn extends ConsumerWidget {
  final bool practiceMode;
  const GameTestBtn(this.practiceMode, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountServiceProvider.notifier);
    final auth = ref.read(authServiceProvider.notifier);
    final hasBlocks = ref.watch(getRootDataProvider).isNotEmpty;
    final manager = ref.read(gameManagerProvider.notifier);
    final gameState = ref.read(gameManagerProvider);
    final toast = ref.read(toastProvider.notifier);
    return BLButton(
        type: hasBlocks ? BtnType.normal : BtnType.grey,
        onPressed: () async {
          if (!hasBlocks) {
            if (!context.mounted) return;
            toast.showToast(context, 'Place a block first.', type: NotifType.error);
            return;
          }
          if (!practiceMode) {
            manager.pauseTimer();
            ref.invalidate(runTimerProvider);
          }
          final premium = await account.isPremium(auth.getUID());
          if (premium == null) {
            if (!context.mounted) return;
            toast.showToast(context, 'Error checking premium status. Try again later.', type: NotifType.error);
          }
          if (premium == true && gameState.testCount < 300) {
            if (!context.mounted) return;
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const TestDialog(),
            );
            gameState.testCount++;
          } else if (premium == false && gameState.testCount < 50) {
            if (!context.mounted) return;
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const TestDialog(),
            );
            gameState.testCount++;
          } else {
            if (!context.mounted) return;
            toast.showToast(context, 'You are out of available tests. Will reset tomorrow.', type: NotifType.error);
          }
          if (!practiceMode) {
            manager.resumeTimer();
            ref.invalidate(runTimerProvider);
          }
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
