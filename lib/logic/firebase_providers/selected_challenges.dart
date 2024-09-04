import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_challenges.g.dart';

@riverpod
Future<List<Challenge>> selectedChallenges(
  SelectedChallengesRef ref,
  List<String> challengeIDs,
) async {
  final errorhandler = ref.read(errorHandlerProvider.notifier);
  final db = FirebaseFirestore.instance;
  List<Challenge> challenges = [];
  for (final id in challengeIDs) {
    try {
      final doc = await db.collection('challenges').doc(id).get();
      if (doc.exists) {
        challenges.add(Challenge.fromFirestore(doc));
      }
    } catch (e) {
      errorhandler.call(e, 'selected challenges');
    }
  }
  return challenges;
}
