import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final String? id;
  final String? roomID;
  final DateTime? dateCreated;
  final int? totalScore; // refers to num of challenges
  final LeaderboardStatus? status;
  Leaderboard({
    this.id,
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
      dateCreated: data['dateCreated'] == null ? null : (data['dateCreated'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (dateCreated != null) {
      toFirestoreMap.addAll({'dateCreated': Timestamp.fromDate(dateCreated!)});
    }
    if (roomID != null) {
      toFirestoreMap.addAll({'roomID': roomID});
    }
    if (totalScore != null) {
      toFirestoreMap.addAll({'totalScore': totalScore});
    }
    if (status != null) {
      toFirestoreMap.addAll({'totalScore': status!.name});
    }
    return toFirestoreMap;
  }
}
