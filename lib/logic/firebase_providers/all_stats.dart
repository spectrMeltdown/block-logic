// import 'package:block_logic/logic/firebase_models/stats.dart';
// import 'package:firebase_database/firebase_database.dart';

// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/all_stats.g.dart';

// @riverpod
// Stream<Stats?> stats(StatsRef ref) async* {
//   final db = FirebaseDatabase.instance;
//   final stream = db.ref('stats').onValue;
//   await for (final stats in stream) {
//     if (stats.snapshot.children.isEmpty) {
//       yield null;
//     } else {
//       final Stats result = Stats();
//       for (final stat in stats.snapshot.children) {
//         if (stat.id == 'total') {
//           final doc = stat as Map;
//           result.copyWith(
//             totalChallengesPlayed: doc['totalChallengesPlayed'],
//             totalRooms: doc['totalRooms'],
//             totalUsers: doc['totalUsers'],
//           );
//         } else if (stat.id == 'weekly') {
//           final doc = stat as Map;
//           result.copyWith(
//             weeklyChallengesPlayed: doc['weeklyChallengesPlayed'],
//             weeklyRooms: doc['weeklyRooms'],
//           );
//         }
//       }
//       yield result;
//     }
//   }
// }
