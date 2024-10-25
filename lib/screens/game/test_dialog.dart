import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/animation_player.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/solution_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestDialog extends ConsumerWidget {
  const TestDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.read(assetsProvider);
    final nav = ref.read(customNavigationProvider.notifier);
    final solutionCheck = ref.read(solutionCheckerProvider.notifier);
    final loadingCode = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BLAnimationPlayer(assets.testLoading),
        const SizedBox(
          height: 15,
        ),
        const BLSmallTitle('Running your code ...')
      ],
    );
    return BLDialog(
        child: FutureBuilder(
            future: solutionCheck.check(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                return genericError('', '');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingCode;
              }
              dPrint('Test data is : ${snapshot.data}');
              if (snapshot.data == null || snapshot.data!.contains('Empty!') || snapshot.data!.isEmpty) {
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
                    snapshot.data!,
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
            }));
  }
}
