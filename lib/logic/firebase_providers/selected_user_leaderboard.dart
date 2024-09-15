import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user_leaderboard.g.dart';

@riverpod
Stream<Leaderboard?> selectedUserLeaderboard(SelectedUserLeaderboardRef ref, String uid) async* {
  if (uid.isNotEmpty) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('leaderboards').where('players', arrayContains: uid).snapshots();
    await for (final query in stream) {
      if (query.docs.isNotEmpty) {
        yield Leaderboard.fromFirestore(query.docs.first);
      }
    }
  } else {
    yield null;
  }
}
