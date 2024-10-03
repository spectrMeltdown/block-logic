import 'package:block_logic/logic/enums.dart';

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

  factory Leaderboard.fromRTDB(dynamic doc) {
    Map data = {};
    if (doc.value != null) {
      data = doc.value as Map;
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
      id: doc.key,
      roomName: data['roomName'] ?? '',
      roomID: data['roomID'] ?? '',
      totalScore: data['totalScore'],
      status: status,
      players: data['players'] == null ? <String>[] : (data['players'] as List<dynamic>).map((player) => player as String).toList(),
      date: data['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['date']),
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (date != null) {
      toJSONMap.addAll({'date': date!.millisecondsSinceEpoch});
    }
    if (roomID != null) {
      toJSONMap.addAll({'roomID': roomID});
    }
    if (roomName != null) {
      toJSONMap.addAll({'roomName': roomName});
    }
    if (totalScore != null) {
      toJSONMap.addAll({'totalScore': totalScore});
    }
    if (status != null) {
      toJSONMap.addAll({'status': status!.name});
    }
    if (players != null) {
      toJSONMap.addAll({'players': players});
    }
    return toJSONMap;
  }
}
