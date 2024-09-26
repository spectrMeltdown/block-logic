import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/animation_player.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/solution_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestDialog extends ConsumerStatefulWidget {
  const TestDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestDialogState();
}

class _TestDialogState extends ConsumerState<TestDialog> {
  late final Assets assets;
  late final CustomNavigation nav;
  @override
  void initState() {
    assets = ref.read(assetsProvider);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final solutionCheck = ref.watch(solutionCheckProvider);
    final gameState = ref.read(gameManagerProvider);
    return BLDialog(
      child: solutionCheck.when(
        data: (solution) {
          if (gameState.dataTree.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BLText(
                  'No blocks to test on.',
                  size: 18,
                ),
                const SizedBox(
                  height: 15,
                ),
                BLButton(type: BtnType.red, onPressed: () => nav.pop(context), child: const BLText('Close'))
              ],
            );
          }
          if (solution == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BLText(
                  'Failed to test solution ...',
                  size: 18,
                ),
                const SizedBox(
                  height: 15,
                ),
                BLButton(type: BtnType.red, onPressed: () => nav.pop(context), child: const BLText('Close'))
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BLSmallTitle('Result:'),
              Flexible(
                  child: BLText(
                solution,
                softWrap: true,
              )),
              const SizedBox(
                height: 15,
              ),
              BLButton(
                type: BtnType.red,
                onPressed: () => nav.pop(context),
                child: const BLText('Close'),
              )
            ],
          );
        },
        error: (error, stackTrace) {
          genericError(error, stackTrace);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BLText(
                'Failed to test solution ...',
                size: 18,
              ),
              const BLText('Internet problem?'),
              const SizedBox(
                height: 15,
              ),
              BLButton(type: BtnType.red, onPressed: () => nav.pop(context), child: const BLText('Close'))
            ],
          );
        },
        loading: () {
          genericLoading();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BLAnimationPlayer(assets.testLoading),
              const SizedBox(
                height: 15,
              ),
              const BLSmallTitle('Running your code ...')
            ],
          );
        },
      ),
    );
  }
}
