import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final String? id; // the doc id. Should be auto generated
  final String? roomID;
  final String? roomName; // needs to be saved in leaderboard in case room gets deleted
  final DateTime? date;
  final int? totalScore; // refers to num of challenges
  final LeaderboardStatus? status;
  final List<String>? players;
  Leaderboard({
    this.roomName,
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
      roomName: data['roomName'] ?? '',
      roomID: data['roomID'] ?? '',
      totalScore: data['totalScore'],
      status: status,
      players: data['players'] == null ? <String>[] : (data['players'] as List<dynamic>).map((player) => player as String).toList(),
      date: data['date'] == null ? null : (data['date'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (date != null) {
      toFirestoreMap.addAll({'date': Timestamp.fromDate(date!)});
    }
    if (roomID != null) {
      toFirestoreMap.addAll({'roomID': roomID});
    }
    if (roomName != null) {
      toFirestoreMap.addAll({'roomName': roomName});
    }
    if (totalScore != null) {
      toFirestoreMap.addAll({'totalScore': totalScore});
    }
    if (status != null) {
      toFirestoreMap.addAll({'status': status!.name});
    }
    if (players != null) {
      toFirestoreMap.addAll({'players': players});
    }
    return toFirestoreMap;
  }
}
