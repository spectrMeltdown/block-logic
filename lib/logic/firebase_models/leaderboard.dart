import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final String? id;
  final String? roomID;
  final DateTime? dateCreated;
  final int? totalScore;
  final LeaderboardStatus? status;
  Leaderboard({
    required this.id,
    this.roomID,
    this.status,
    this.dateCreated,
    this.totalScore,
  });

  factory Leaderboard.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }
    LeaderboardStatus? status;
    if (data['status'] == LeaderboardStatus.complete.name) {
      status = LeaderboardStatus.complete;
    } else if (data['status'] == LeaderboardStatus.incomplete.name) {
      status = LeaderboardStatus.incomplete;
    } else if (data['status'] == LeaderboardStatus.pending.name) {
      status = LeaderboardStatus.pending;
    }

    return Leaderboard(
      id: doc.id,
      roomID: data['roomID'] ?? '',
      totalScore: data['totalScore'] ?? '',
      status: status,
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
    if (leaderboard.status != null) {
      toFirestoreMap.addAll({'totalScore': leaderboard.status!.name});
    }
    return toFirestoreMap;
  }
}
