import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/game/logic/all_blocks.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialChallengeSelector extends ConsumerWidget {
  const TutorialChallengeSelector({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final List<Challenge> practiceChallenges = [
      Challenge(
        id: 'testing2',
        name: 'Give me a five!',
        shortDescription: 'Print the number 5',
        additionalInfo: 'This should be a simple one..',
        difficulty: Difficulty.beginner,
        blocks: AllBlocks().beginnerTesting(),
        solutionMatch: [5],
      ),
      if (kDebugMode)
        Challenge(
          blocks: AllBlocks().getAll(),
          difficulty: Difficulty.advanced,
          shortDescription: 'No Challenge here!',
          solutionMatch: [5],
          name: 'Testing',
        )
    ];
    return Scaffold(
      body: Background(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                const Row(
                  children: [
                    BLBackButton(),
                    BLSmallTitle(
                      'Select a challenge',
                      bottomPadding: 0,
                    )
                  ],
                ),
                const SizedBox(height: 15),
                ...List.generate(
                  practiceChallenges.length,
                  (i) => TutorialChallengeSelectorItem(
                    practiceChallenges[i],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialChallengeSelectorItem extends ConsumerWidget {
  final Challenge challenge;
  const TutorialChallengeSelectorItem(this.challenge, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    final blui = ref.read(bLUIProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: BLCard(
          color: blui.getTutorialColor(TutorialType.values[getRandomInt(0, TutorialType.values.length - 1)]),
          onPressed: () {
            nav.push(
                context,
                Scaffold(
                  body: Background(
                      child: SafeArea(
                          child: GameChallenge(
                    key: ValueKey(challenge.id),
                    currentChallenge: 0,
                    roomName: 'Practice Room',
                    challenge: challenge,
                    challengeCount: 1,
                    practiceMode: true,
                  ))),
                ));
          },
          child: Center(child: BLSmallTitle(challenge.name ?? ''))),
    );
  }
}
