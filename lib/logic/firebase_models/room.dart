import 'package:block_logic/logic/enums.dart';
import 'package:firebase_database/firebase_database.dart';

class Room {
  final String? id;
  final String? hostID;
  final String? name;
  final String? password;
  final List<String>? players;
  final List<String>? challengeIDs;
  final int? maxPlayers;
  final bool? adminLocked;
  final RoomStatus? status;
  final String? currentLeaderboardID;
  Room({
    this.adminLocked,
    this.id,
    this.players,
    this.currentLeaderboardID,
    this.hostID,
    this.challengeIDs,
    this.name,
    this.status,
    this.password,
    this.maxPlayers,
  });

  factory Room.fromRTDB(DataSnapshot doc) {
    Map data = {};
    if (doc.value != null) {
      data = doc.value as Map;
    }
    RoomStatus? status;
    if (data['status'] == RoomStatus.available.name) {
      status = RoomStatus.available;
    } else if (data['status'] == RoomStatus.finalizing.name) {
      status = RoomStatus.finalizing;
    } else if (data['status'] == RoomStatus.inGame.name) {
      status = RoomStatus.inGame;
    } else if (data['status'] == RoomStatus.locked.name) {
      status = RoomStatus.locked;
    }
    return Room(
      id: doc.key,
      players: data['players'] == null ? null : (data['players'] as List).map((item) => item as String).toList(),
      status: status,
      hostID: data['hostID'],
      challengeIDs: data['challengeIDs'] == null ? null : (data['challengeIDs'] as List).map((item) => item as String).toList(),
      name: data['name'] ?? '',
      password: data['password'],
      currentLeaderboardID: data['currentLeaderboardID'],
      maxPlayers: data['maxPlayers'],
      adminLocked: data['adminLocked'],
    );
  }

  Room copyWith({
    String? id,
    String? hostID,
    String? name,
    String? password,
    List<String>? players,
    List<String>? challengeIDs,
    int? maxPlayers,
    bool? adminLocked,
    RoomStatus? status,
    String? currentLeaderboardID,
  }) {
    return Room(
      id: id ?? this.id,
      hostID: hostID ?? this.hostID,
      name: name ?? this.name,
      password: password ?? this.password,
      players: players ?? this.players,
      challengeIDs: challengeIDs ?? this.challengeIDs,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      adminLocked: adminLocked ?? this.adminLocked,
      status: status ?? this.status,
      currentLeaderboardID: currentLeaderboardID ?? this.currentLeaderboardID,
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (challengeIDs != null) {
      toJSONMap.addAll({'challengeIDs': challengeIDs});
    }
    if (players != null) {
      toJSONMap.addAll({'players': players});
    }
    if (maxPlayers != null) {
      toJSONMap.addAll({'maxPlayers': maxPlayers});
    }
    if (hostID != null) {
      toJSONMap.addAll({'hostID': hostID});
    }
    if (name != null) {
      toJSONMap.addAll({'name': name});
    }
    if (password != null) {
      toJSONMap.addAll({'password': password});
    }
    if (status != null) {
      toJSONMap.addAll({'status': status!.name});
    }
    if (adminLocked != null) {
      toJSONMap.addAll({'adminLocked': adminLocked});
    }
    if (currentLeaderboardID != null) {
      toJSONMap.addAll({'currentLeaderboardID': currentLeaderboardID});
    }
    return toJSONMap;
  }
}
