import 'package:block_logic/components/background.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/screens/game/game_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRoom extends ConsumerStatefulWidget {
  final String roomID;
  const GameRoom({required this.roomID, super.key});

  @override
  ConsumerState<GameRoom> createState() => _GameRoomState();
}

class _GameRoomState extends ConsumerState<GameRoom> {
  late int currentChallenge;
  late GameManagerState gameManagerState;

  final testingRoom = Room(
    id: 'id',
    icon: 'icon',
    hostID: 'hostID',
    challengeIDs: [],
    name: 'Willow\'s Room',
    password: 'password',
    players: [],
    maxPlayers: 5,
    status: RoomStatus.available,
  );

  final testingChallenges = [
    Challenge(
      id: 'id',
      name: 'Leap Year Check',
      shortDescription: 'Check if the given year is a leap year.',
      additionalInfo:
          'A leap year has 366 days, with an extra day in February (29 days instead of 28). It occurs every four years to keep the calendar year aligned with the solar year.',
      limitations: ['5 block lines', 'No functions', 'No classes'],
      blocks: AllBlocks.getAllBlocks(),
      difficulty: 'Intermediate',
      tags: ['conditionals', ''],
    ),
    Challenge(
      id: 'id',
      name: 'Vowel Count',
      shortDescription: 'Count the number of vowels in a given string.',
      additionalInfo: '',
      limitations: ['2 block lines', 'Use one function', ''],
      blocks: AllBlocks.getAllBlocks(),
      difficulty: 'Beginner',
      tags: [
        'conditionals',
        'functions',
      ],
    )
  ];
  @override
  Widget build(BuildContext context) {
    //TODO: have a gamehost controller that will react to host actions, like when game start
    //TODO: when game starts, display challenge and limitation overlay
    //final gameHost = ref.watch(gameHostProvider);
    ref.watch(gameManagerStateProvider);
    //final room = ref.read(GameRoomProvider(widget.roomID));

    currentChallenge = gameManagerState.getCurrentChallenge();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: GameChallenge(
          roomName: testingRoom.name ?? '',
          challenge: testingChallenges[currentChallenge],
          challengeCount: testingChallenges.length,
        ),
      ),
    );

    // room.when(
    //   data: (room) {
    //     if (room == null) return blankLoading();
    //     final challenges = ref.read(ChallengesRoomProvider(room.challengeIDs));
    //     challenges.when(
    //         data: (challenges) {
    //           if (challenges.isEmpty) return blankLoading();
    //           // TODO: insert here when ready to do testing with network
    //         },
    //         error: genericError,
    //         loading: genericLoading);
    //   },
    //   error: genericError,
    //   loading: genericLoading,
    // );
  }

  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    super.initState();
  }
}
