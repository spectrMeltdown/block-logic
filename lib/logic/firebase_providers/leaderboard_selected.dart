import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/leaderboard_selected.g.dart';

@Riverpod()
Stream<List<Leaderboard>?> selectedLeaderboard(
    SelectedLeaderboardRef ref, String roomID) async* {
  if (roomID.isEmpty) yield null;
  final db = FirebaseFirestore.instance;
  final leaderboardsStream = db
      .collection('leaderboards')
      .where(roomID, isEqualTo: roomID)
      .snapshots();
  await for (final leaderboards in leaderboardsStream) {
    final List<Leaderboard> result = [];
    if (leaderboards.docs.isNotEmpty) {
      for (final leaderboard in leaderboards.docs) {
        result.add(Leaderboard.fromFirestore(leaderboard));
      }
    }
    yield result;
  }
}
