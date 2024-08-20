import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_challenge.g.dart';

@Riverpod(dependencies: [])
Stream<Challenge?> selectedChallenge(
  SelectedChallengeRef ref,
  String challengeID,
) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('challenges').doc(challengeID).snapshots();
  await for (final doc in stream) {
    if (!doc.exists) {
      yield null;
    } else {
      yield Challenge.fromFirestore(doc);
    }
  }
}
