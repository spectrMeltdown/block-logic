import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/leaderboards.g.dart';

@Riverpod(dependencies: [])
Stream<List<Leaderboard>?> leaderboards(LeaderboardsRef ref, String id) async* {
  final db = FirebaseFirestore.instance;
  final stream =
      db.collection('leaderboards').where('id', isEqualTo: id).snapshots();
  await for (final leaderboards in stream) {
    final List<Leaderboard> result = [];
    if (leaderboards.docs.isNotEmpty) {
      for (final leaderboard in leaderboards.docs) {
        result.add(Leaderboard.fromFirestore(leaderboard));
      }
    }
    yield result;
  }
}
