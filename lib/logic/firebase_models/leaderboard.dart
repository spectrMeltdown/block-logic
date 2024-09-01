import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final String? id;
  final String? roomID;
  final DateTime? date;
  final int? totalScore; // refers to num of challenges
  final LeaderboardStatus? status;
  final List<String>? players;
  Leaderboard({
    this.id,
    this.players,
    this.roomID,
    this.status,
    this.date,
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
      players: data['players'] ?? [],
      date: data['date'] == null ? null : (data['date'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (date != null) {
      toFirestoreMap.addAll({'dateCreated': Timestamp.fromDate(date!)});
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
    if (players != null) {
      toFirestoreMap.addAll({'players': players});
    }
    return toFirestoreMap;
  }
}
