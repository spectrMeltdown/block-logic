import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/challenges.g.dart';

@Riverpod(dependencies: [])
Stream<List<Challenge>> challenges(ChallengesRef ref) async* {
  final db = ref.watch(dbProvider).i;
  final stream = db.collection('challenges').snapshots();
  await for (final query in stream) {
    final List<Challenge> result = [];
    if (query.docs.isNotEmpty) {
      for (final queryDoc in query.docs) {
        result.add(Challenge.fromFirestore(queryDoc));
      }
    }
    yield result;
  }
}
