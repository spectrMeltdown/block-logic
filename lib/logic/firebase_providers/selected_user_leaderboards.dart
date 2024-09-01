import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user_leaderboards.g.dart';

@riverpod
Stream<List<Leaderboard>> selectedUserLeaderboards(SelectedUserLeaderboardsRef ref, String uid) async* {
  if (uid.isNotEmpty) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('leaderboards').where('players', arrayContains: uid).snapshots();
    await for (final query in stream) {
      final List<Leaderboard> result = [];
      if (query.docs.isNotEmpty) {
        for (final doc in query.docs) {
          result.add(Leaderboard.fromFirestore(doc));
        }
        // TODO: filter based on datetime, return the list
        //result.sort((a, b) {return DateTime.;});
      }
      yield result;
    }
  }
}
