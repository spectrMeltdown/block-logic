import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  //final String? icon;
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
    //this.icon,
    this.hostID,
    this.challengeIDs,
    this.name,
    this.status,
    this.password,
    this.maxPlayers,
  });

  factory Room.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
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
      id: doc.id,
      players: data['players'] == null ? null : (data['players'] as List).map((item) => item as String).toList(),
      status: status,
      // icon: data['icon'],
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

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (challengeIDs != null) {
      toFirestoreMap.addAll({'challengeIDs': challengeIDs});
    }
    if (players != null) {
      toFirestoreMap.addAll({'players': players});
    }
    if (maxPlayers != null) {
      toFirestoreMap.addAll({'maxPlayers': maxPlayers});
    }
    if (hostID != null) {
      toFirestoreMap.addAll({'hostID': hostID});
    }
    // if (icon != null) {
    //   toFirestoreMap.addAll({'icon': icon});
    // }
    if (name != null) {
      toFirestoreMap.addAll({'name': name});
    }

    /// Password should be encrypted before passing to this function
    if (password != null) {
      toFirestoreMap.addAll({'password': password});
    }
    if (status != null) {
      toFirestoreMap.addAll({'status': status!.name});
    }
    if (adminLocked != null) {
      toFirestoreMap.addAll({'adminLocked': adminLocked});
    }
    if (currentLeaderboardID != null) {
      toFirestoreMap.addAll({'currentLeaderboardID': currentLeaderboardID});
    }
    return toFirestoreMap;
  }
}
