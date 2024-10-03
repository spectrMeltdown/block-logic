import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_challenge.g.dart';

@riverpod
Stream<Challenge?> selectedChallenge(
  SelectedChallengeRef ref,
  String challengeID,
) async* {
  final db = FirebaseDatabase.instance;
  final stream = db.ref('challenges/$challengeID').onValue;
  await for (final doc in stream) {
    if (!doc.snapshot.exists) {
      yield null;
    } else {
      yield Challenge.fromRTDB(doc.snapshot);
    }
  }
}
