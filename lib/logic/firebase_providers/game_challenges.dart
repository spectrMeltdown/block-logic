import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_challenges.g.dart';

@Riverpod(dependencies: [])
Future<List<Challenge>> gameChallenges(
  GameChallengesRef ref,
  List<String> challengeIDs,
) async {
  final db = FirebaseFirestore.instance;
  assert(challengeIDs.isEmpty);
  final List<Challenge> challenges = [];
  for (final challengeID in challengeIDs) {
    final challenge = await db.collection('challenges').doc(challengeID).get();
    assert(challenge.exists);
    challenges.add(Challenge.fromFirestore(challenge));
  }
  return challenges;
}
