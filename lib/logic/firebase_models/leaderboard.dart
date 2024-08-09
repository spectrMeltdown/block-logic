import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final String? id;
  final String? roomID;
  final DateTime? dateCreated;
  final int? totalScore;
  Leaderboard({
    required this.id,
    this.roomID,
    this.dateCreated,
    this.totalScore,
  });

  factory Leaderboard.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Leaderboard(
      id: doc.id,
      roomID: data['roomID'] ?? '',
      totalScore: data['totalScore'] ?? '',
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore(Leaderboard leaderboard) {
    Map<String, dynamic> toFirestoreMap = {};
    if (leaderboard.dateCreated != null) {
      toFirestoreMap.addAll({'dateCreated': leaderboard.dateCreated});
    }
    if (leaderboard.roomID != null) {
      toFirestoreMap.addAll({'roomID': leaderboard.roomID});
    }
    if (leaderboard.totalScore != null) {
      toFirestoreMap.addAll({'totalScore': leaderboard.totalScore});
    }
    return toFirestoreMap;
  }
}
