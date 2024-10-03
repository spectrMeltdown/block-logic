// class Stats {
//   final String? id;
//   final int? totalUsers;
//   final int? totalChallengesPlayed;
//   final int? totalRooms;
//   final int? weeklyChallengesPlayed;
//   final int? weeklyRooms;

//   Stats({
//     this.id,
//     this.totalUsers,
//     this.totalChallengesPlayed,
//     this.totalRooms,
//     this.weeklyChallengesPlayed,
//     this.weeklyRooms,
//   });

//   factory Stats.fromRTDB(DataSnapshot doc) {
//     Map<String, dynamic> data = {};
//     if (doc.value != null) {
//       data = doc.value as Map<String, dynamic>;
//     }

//     return Stats(
//       id: doc.key,
//       totalChallengesPlayed: data['totalChallenges'],
//       totalRooms: data['totalRooms'],
//       totalUsers: data['totalUsers'],
//       weeklyChallengesPlayed: data['weeklyChallenges'],
//       weeklyRooms: data['weeklyRooms'],
//     );
//   }

//   Stats copyWith({
//     int? totalUsers,
//     int? totalChallengesPlayed,
//     int? totalRooms,
//     int? weeklyChallengesPlayed,
//     int? weeklyRooms,
//   }) =>
//       Stats(
//         totalUsers: totalUsers ?? this.totalUsers,
//         totalChallengesPlayed: totalChallengesPlayed ?? this.totalChallengesPlayed,
//         totalRooms: totalRooms ?? this.totalRooms,
//         weeklyChallengesPlayed: weeklyChallengesPlayed ?? this.weeklyChallengesPlayed,
//         weeklyRooms: weeklyRooms ?? this.weeklyRooms,
//       );

//   Map<String, dynamic> toJSON() {
//     Map<String, dynamic> toJSONMap = {};
//     if (totalChallengesPlayed != null) {
//       toJSONMap.addAll({'totalChallenges': totalChallengesPlayed});
//     }
//     if (totalRooms != null) {
//       toJSONMap.addAll({'totalRooms': totalRooms});
//     }
//     if (totalUsers != null) {
//       toJSONMap.addAll({'totalUsers': totalUsers});
//     }
//     if (weeklyChallengesPlayed != null) {
//       toJSONMap.addAll({'weeklyChallenges': weeklyChallengesPlayed});
//     }
//     if (weeklyRooms != null) {
//       toJSONMap.addAll({'weeklyRooms': weeklyRooms});
//     }
//     return toJSONMap;
//   }
// }
