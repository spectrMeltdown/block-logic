import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/game/logic/all_blocks.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/screens/game/game_challenge.dart';

class TestGame extends ConsumerStatefulWidget {
  const TestGame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestGameState();
}

class _TestGameState extends ConsumerState<TestGame> {
  late GameManager gameManager;
  List<Challenge> challenges = [];

  int currentChallenge = 0;
  @override
  void initState() {
    super.initState();
    gameManager = ref.read(gameManagerProvider.notifier);
    challenges = [
      Challenge(
        id: gameManager.getUID(),
        name: 'Testing 1',
        shortDescription: 'Testing 1',
        solutionMatch: [true],
        blocks: AllBlocks().getAll(),
      ),
      Challenge(
        id: gameManager.getUID(),
        name: 'Testing 2',
        shortDescription: 'Testing 2',
        solutionMatch: ['Hello, World!'],
        blocks: AllBlocks().helloWorld(),
      ),
      Challenge(
        id: gameManager.getUID(),
        name: 'Testing 3',
        shortDescription: 'Testing 3',
        solutionMatch: ['Python is Awesome!'],
        blocks: AllBlocks().pythonIsAwesome(),
      ),
    ];
  }

  void updateChallenge() {
    if (currentChallenge < challenges.length - 1) {
      setState(() {
        currentChallenge++;
      });
    } else {
      setState(() {
        currentChallenge = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final processing = ref.watch(processingProvider);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Background(
            child: SafeArea(
              child: GameChallenge(
                updateChallenge: updateChallenge,
                currentChallenge: currentChallenge,
                roomName: 'Testing',
                challenge: challenges[currentChallenge],
                challengeCount: challenges.length,
                // practiceMode: true,
              ),
            ),
          ),
          Visibility(
              visible: processing,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const BLLoading(
                  message: 'Processing...',
                ),
              ))
        ],
      ),
    );
  }
}
