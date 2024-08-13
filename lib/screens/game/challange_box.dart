import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/dialog_challenge_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengeBox extends ConsumerWidget {
  final Challenge challenge;
  const ChallengeBox({
    required this.challenge,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.read(gameManagerProvider.notifier);
    final challengeDialog = ref.read(dialogServiceStateProvider);
    return GestureDetector(
      onTapUp: (details) async {
        gameManager.pauseTimer();
        await challengeDialog.show(
            context, DialogChallengeInfo(challenge: challenge));
        gameManager.resumeTimer();
      },
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.9),
        child: BLPanel(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      BLText(
                        'Challenge:',
                        bold: true,
                        color: BLUI().getAppColor('blue'),
                      ),
                      BLText('${challenge.shortDescription}\n', size: 14),
                      BLText(
                        'Limitations:',
                        bold: true,
                        color: BLUI().getAppColor('orange'),
                      ),
                      challenge.limitations!.isEmpty
                          ? const BLText('No limitations set', size: 14)
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: challenge.limitations!.length,
                              itemBuilder: (context, i) {
                                return BLText('• ${challenge.limitations![i]}',
                                    size: 14);
                              })
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
