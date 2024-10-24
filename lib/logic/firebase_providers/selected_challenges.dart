import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_challenges.g.dart';

@riverpod
Future<List<Challenge>> selectedChallenges(
  Ref ref,
  List<String> challengeIDs,
) async {
  final errorhandler = ref.read(errorHandlerProvider.notifier);
  final db = FirebaseDatabase.instance;
  List<Challenge> challenges = [];
  for (final id in challengeIDs) {
    try {
      final doc = await db.ref('challenges/$id').get();
      if (doc.exists) {
        challenges.add(Challenge.fromRTDB(doc));
      }
    } catch (e) {
      errorhandler.call(e, 'selected challenges');
    }
  }
  return challenges;
}
