import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user_leaderboard.g.dart';

@riverpod
Stream<Leaderboard?> selectedUserLeaderboard(SelectedUserLeaderboardRef ref, String uid) async* {
  if (uid.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('leaderboards').onValue;
    await for (final query in stream) {
      if (query.snapshot.children.isNotEmpty) {
        yield Leaderboard.fromRTDB(query.snapshot.children.firstWhere((i) => ((i.value as Map<String, dynamic>)['players'] as List).contains(uid)));
      }
    }
  } else {
    yield null;
  }
}
