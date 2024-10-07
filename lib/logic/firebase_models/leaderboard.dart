import 'package:block_logic/logic/enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

  factory Leaderboard.fromRTDB(Object? doc, [String? key]) {
    Map data = {};
    if (doc is DataSnapshot) {
      debugPrint('Is datasnapshot');
      if (doc.value != null) {
        debugPrint('Converted to map');
        data = doc.value as Map;
      }
    }
    debugPrint('RTBD type was $doc, ${doc.runtimeType}');

    LeaderboardStatus? status;
    if (data['status'] == LeaderboardStatus.complete.name) {
      status = LeaderboardStatus.complete;
    } else if (data['status'] == LeaderboardStatus.incomplete.name) {
      status = LeaderboardStatus.incomplete;
    } else if (data['status'] == LeaderboardStatus.pending.name) {
      status = LeaderboardStatus.pending;
    }

    return Leaderboard(
      id: doc is DataSnapshot ? doc.key : key,
      roomName: data['roomName'] ?? '',
      roomID: data['roomID'] ?? '',
      totalScore: data['totalScore'],
      status: status,
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
    LeaderboardStatus? status,
    List<String>? players,
  }) {
    return Leaderboard(
      id: id ?? this.id,
      roomID: roomID ?? this.roomID,
      roomName: roomName ?? this.roomName,
      date: date ?? this.date,
      totalScore: totalScore ?? this.totalScore,
      status: status ?? this.status,
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
    if (status != null) {
      toJSONMap.addAll({'status': status!.name});
    }
    if (players != null) {
      toJSONMap.addAll({'players': players});
    }
    return toJSONMap;
  }
}
