import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_challenges.g.dart';

@riverpod
Future<List<Challenge>> gameChallenges(
  Ref ref,
  List<String> challengeIDs,
) async {
  final db = FirebaseDatabase.instance;
  assert(challengeIDs.isEmpty);
  final List<Challenge> challenges = [];
  for (final challengeID in challengeIDs) {
    final challenge = await db.ref('challenges/$challengeID').get();
    assert(challenge.exists);
    challenges.add(Challenge.fromRTDB(challenge));
  }
  return challenges;
}
