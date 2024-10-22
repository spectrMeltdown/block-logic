import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengeDetails extends ConsumerWidget {
  final Challenge challenge;
  const ChallengeDetails({required this.challenge, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Challenge Details'),
        const SizedBox(height: 10),
        BLText('Name: ${challenge.name}'),
        const SizedBox(
          height: 10,
        ),
        BLText('Short Description: ${challenge.shortDescription ?? 'No short description set.'}'),
        const SizedBox(
          height: 10,
        ),
        const BLText('Additional Info: '),
        BLText(
          challenge.additionalInfo ?? 'No additional info found.',
          softWrap: true,
        ),
        const SizedBox(height: 10),
        // const BLText('Limitations: '),
        // if (challenge.limitations == null || challenge.limitations!.isEmpty) const BLText('No limitations set.'),
        // ...List.generate(challenge.limitations!.length, (i) {
        //   return BLText(challenge.limitations![i]);
        // }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BLTextButton(
              onPressed: () => nav.pop(context),
              child: const BLText(
                'Back',
                color: Colors.red,
                bold: true,
                size: 18,
              ),
            ),
          ],
        )
      ],
    ));
  }
}
