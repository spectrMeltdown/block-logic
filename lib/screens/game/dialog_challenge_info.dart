import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogChallengeInfo extends ConsumerWidget {
  final Challenge challenge;
  const DialogChallengeInfo({required this.challenge, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider);
    return BLDialog(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Challenge:'),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Wrap(
            children: [
              BLText(challenge.shortDescription ?? 'No description provided'),
              const BLText('\n'),
              BLText(challenge.additionalInfo ?? 'No additional info provided'),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const BLSmallTitle('Limitations:'),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(challenge.limitations!.length, (i) {
              return Wrap(children: [BLText('• ${challenge.limitations![i]}')]);
            }),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
            child: BLButton(
                type: BtnType.red,
                onPressed: () => nav.pop(context),
                paddingX: 80,
                child: const BLText(
                  'Back',
                )))
      ],
    ));
  }
}
