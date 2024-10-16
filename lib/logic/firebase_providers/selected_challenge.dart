import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_challenge.g.dart';

@riverpod
Stream<Challenge?> selectedChallenge(
  SelectedChallengeRef ref,
  String challengeID, {
  bool? createMode,
}) async* {
  final db = FirebaseDatabase.instance;
  Challenge? result;
  if (createMode != null && createMode == true) {
    yield Challenge();
  } else {
    db.ref('challenges/$challengeID').onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        result = Challenge.fromRTDB(snapshot);
      }
    });
    yield result;
  }
}
