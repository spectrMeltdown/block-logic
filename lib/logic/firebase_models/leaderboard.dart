import 'package:block_logic/logic/dev.dart';
import 'package:firebase_database/firebase_database.dart';

class Leaderboard {
  final String? id; // the doc id. Should be auto generated
  final String? roomID;
  final String? roomName; // needs to be saved in leaderboard in case room gets deleted
  final DateTime? date;
  final int? totalScore; // refers to num of challenges
  final List<String>? players;
  Leaderboard({
    this.roomName,
    this.id,
    this.players,
    this.roomID,
    this.date,
    this.totalScore,
  });

  factory Leaderboard.fromRTDB(Object? doc, [String? key]) {
    Map<String, dynamic> data = {};

    if (doc is Map<Object?, Object?>) {
      data = (doc).map((k, v) => MapEntry(k as String, v));
    } else if (doc is DataSnapshot && doc.value != null) {
      data = (doc.value as Map<Object?, Object?>).map((k, v) => MapEntry(k as String, v));
    } else {
      dPrint('Unknown type!!');
    }

    // LeaderboardStatus? status;
    // if (data['status'] == LeaderboardStatus.complete.name) {
    //   status = LeaderboardStatus.complete;
    // } else if (data['status'] == LeaderboardStatus.incomplete.name) {
    //   status = LeaderboardStatus.incomplete;
    // } else if (data['status'] == LeaderboardStatus.pending.name) {
    //   status = LeaderboardStatus.pending;
    // }

    return Leaderboard(
      id: doc is DataSnapshot && doc.key != null ? doc.key : key,
      roomName: data['roomName'] ?? '',
      roomID: data['roomID'] ?? '',
      totalScore: data['totalScore'],
      // status: status,
      players: data['players'] == null ? <String>[] : (data['players'] as List<dynamic>).map((player) => player as String).toList(),
      date: data['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['date']),
    );
  }

  Leaderboard copyWith({
    String? id,
    String? roomID,
    String? roomName,
    DateTime? date,
    int? totalScore,
    // LeaderboardStatus? status,
    List<String>? players,
  }) {
    return Leaderboard(
      id: id ?? this.id,
      roomID: roomID ?? this.roomID,
      roomName: roomName ?? this.roomName,
      date: date ?? this.date,
      totalScore: totalScore ?? this.totalScore,
      // status: status ?? this.status,
      players: players ?? this.players,
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
    // if (status != null) {
    //   toJSONMap.addAll({'status': status!.name});
    // }
    if (players != null) {
      toJSONMap.addAll({'players': players});
    }
    return toJSONMap;
  }
}
