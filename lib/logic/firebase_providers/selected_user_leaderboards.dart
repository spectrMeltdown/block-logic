import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user_leaderboards.g.dart';

@riverpod
Stream<List<Leaderboard>> selectedUserLeaderboards(Ref ref, String uid) async* {
  if (uid.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('leaderboards').onValue;
    await for (final query in stream) {
      List<Leaderboard> result = [];
      if (query.snapshot.children.isNotEmpty) {
        for (final doc in query.snapshot.children) {
          result.add(Leaderboard.fromRTDB(doc));
        }
        // TODO: filter based on datetime, return the list
        //result.sort((a, b) {return DateTime.;});
      }
      result = result.where((i) => i.players!.contains(uid)).toList();
      yield result;
    }
  }
}
