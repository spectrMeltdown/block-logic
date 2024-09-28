import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/block_data_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialChallengeSelector extends ConsumerStatefulWidget {
  const TutorialChallengeSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TutorialChallengeSelectorState();
}

class _TutorialChallengeSelectorState extends ConsumerState<TutorialChallengeSelector> {
  late final CustomNavigation nav;
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
  ];
  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 10,
                ),
                BLCard(
                    color: Colors.amber,
                    onPressed: () {
                      nav.push(
                          context,
                          Scaffold(
                            body: Background(
                                child: SafeArea(
                                    child: GameChallenge(
                              currentChallenge: 0,
                              roomName: 'Practice Room',
                              challenge: Challenge(
                                blocks: AllBlocks().getAll(),
                                difficulty: Difficulty.advanced,
                                shortDescription: 'No Challenge here!',
                                solutionMatch: [5],
                                name: 'Testing',
                              ),
                              challengeCount: 1,
                              practiceMode: true,
                            ))),
                          ));
                    },
                    child: Center(child: BLSmallTitle('All blocks')))
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
    return BLCard(
        color: Colors.blue,
        onPressed: () {
          nav.push(
              context,
              Scaffold(
                body: Background(
                    child: SafeArea(
                        child: GameChallenge(
                  currentChallenge: 0,
                  roomName: 'Practice Room',
                  challenge: challenge,
                  challengeCount: 1,
                  practiceMode: true,
                ))),
              ));
        },
        child: Center(child: BLSmallTitle(challenge.name ?? '')));
  }
}
