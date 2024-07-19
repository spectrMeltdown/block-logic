import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_leaderboards.g.dart';

@Riverpod(dependencies: [])
Stream<List<Leaderboard>> ownRoomLeaderboards(
    OwnRoomLeaderboardsRef ref, String roomID) async* {
  final db = ref.watch(dbProvider).i;
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
