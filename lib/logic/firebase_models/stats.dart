class Stats {
  final String? id;
  final int? totalUsers;
  final int? totalChallengesPlayed;
  final int? totalRooms;
  final int? weeklyChallengesPlayed;
  final int? weeklyRooms;

  Stats({
    this.id,
    this.totalUsers,
    this.totalChallengesPlayed,
    this.totalRooms,
    this.weeklyChallengesPlayed,
    this.weeklyRooms,
  });

  factory Stats.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Stats(
      id: doc.id,
      totalChallengesPlayed: data['totalChallenges'],
      totalRooms: data['totalRooms'],
      totalUsers: data['totalUsers'],
      weeklyChallengesPlayed: data['weeklyChallenges'],
      weeklyRooms: data['weeklyRooms'],
    );
  }

  Stats copyWith({
    int? totalUsers,
    int? totalChallengesPlayed,
    int? totalRooms,
    int? weeklyChallengesPlayed,
    int? weeklyRooms,
  }) =>
      Stats(
        totalUsers: totalUsers ?? this.totalUsers,
        totalChallengesPlayed:
            totalChallengesPlayed ?? this.totalChallengesPlayed,
        totalRooms: totalRooms ?? this.totalRooms,
        weeklyChallengesPlayed:
            weeklyChallengesPlayed ?? this.weeklyChallengesPlayed,
        weeklyRooms: weeklyRooms ?? this.weeklyRooms,
      );
  Map<String, dynamic> toFirestore(Stats stats) {
    Map<String, dynamic> toFirestoreMap = {};
    if (stats.totalChallengesPlayed != null) {
      toFirestoreMap.addAll({'totalChallenges': stats.totalChallengesPlayed});
    }
    if (stats.totalRooms != null) {
      toFirestoreMap.addAll({'totalRooms': stats.totalRooms});
    }
    if (stats.totalUsers != null) {
      toFirestoreMap.addAll({'totalUsers': stats.totalUsers});
    }
    if (stats.weeklyChallengesPlayed != null) {
      toFirestoreMap.addAll({'weeklyChallenges': stats.weeklyChallengesPlayed});
    }
    if (stats.weeklyRooms != null) {
      toFirestoreMap.addAll({'weeklyRooms': stats.weeklyRooms});
    }
    return toFirestoreMap;
  }
}
