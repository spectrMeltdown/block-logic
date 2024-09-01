import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_leaderboard.g.dart';

@riverpod
Stream<Leaderboard?> selectedLeaderboard(SelectedLeaderboardRef ref, String leaderboardID) async* {
  if (leaderboardID.isNotEmpty) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('leaderboards').doc(leaderboardID).snapshots();
    await for (final doc in stream) {
      if (doc.exists) {
        yield Leaderboard.fromFirestore(doc);
      }
    }
  }
}
