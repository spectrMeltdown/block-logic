import 'package:block_logic/logic/firebase_models/stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_stats.g.dart';

@riverpod
Stream<Stats?> stats(StatsRef ref) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('stats').snapshots();
  await for (final stats in stream) {
    if (stats.docs.isEmpty) {
      yield null;
    } else {
      final Stats result = Stats();
      for (final stat in stats.docs) {
        if (stat.id == 'total') {
          final doc = stat as Map;
          result.copyWith(
            totalChallengesPlayed: doc['totalChallengesPlayed'],
            totalRooms: doc['totalRooms'],
            totalUsers: doc['totalUsers'],
          );
        } else if (stat.id == 'weekly') {
          final doc = stat as Map;
          result.copyWith(
            weeklyChallengesPlayed: doc['weeklyChallengesPlayed'],
            weeklyRooms: doc['weeklyRooms'],
          );
        }
      }
      yield result;
    }
  }
}
