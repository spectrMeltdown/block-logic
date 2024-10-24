import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_challenge.g.dart';

@riverpod
Future<Challenge?> selectedChallenge(
  Ref ref,
  String challengeID, {
  bool? createMode,
}) async {
  final db = FirebaseDatabase.instance;
  Challenge? result;
  if (createMode != null && createMode == true) {
    return Challenge();
  } else {
    await db.ref('challenges/$challengeID').get().then((snap) {
      if (snap.exists) {
        result = Challenge.fromRTDB(snap);
      }
    });
    return result;
  }
}
