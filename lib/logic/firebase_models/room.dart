import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String? id;
  final String? hostID;
  final String? icon;
  final String? name;
  final String? password;
  final List<String>? players;
  final List<String>? challengeIDs;
  final int? maxPlayers;
  final RoomStatus? status;
  Room({
    this.id,
    this.players,
    this.icon,
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
    }
    return Room(
      id: doc.id,
      players: data['players'] == null
          ? null
          : (data['players'] as List).map((item) => item as String).toList(),
      status: status,
      icon: data['icon'],
      hostID: data['hostID'],
      challengeIDs: data['challengeIDs'] == null
          ? null
          : (data['challengeIDs'] as List)
              .map((item) => item as String)
              .toList(),
      name: data['name'] ?? '',
      password: data['password'],
      maxPlayers: data['maxPlayers'],
    );
  }

  Map<String, dynamic> toFirestore(Room room) {
    Map<String, dynamic> toFirestoreMap = {};
    if (room.challengeIDs != null) {
      toFirestoreMap.addAll({'challengeIDs': room.challengeIDs});
    }
    if (room.players != null) {
      toFirestoreMap.addAll({'players!.length': room.players});
    }
    if (room.hostID != null) {
      toFirestoreMap.addAll({'hostID': room.hostID});
    }
    if (room.icon != null) {
      toFirestoreMap.addAll({'icon': room.icon});
    }
    if (room.name != null) {
      toFirestoreMap.addAll({'name': room.name});
    }
    if (room.password != null) {
      toFirestoreMap.addAll({'password': room.password});
    }
    if (room.status != null) {
      toFirestoreMap.addAll({'status': room.status!.name});
    }
    return toFirestoreMap;
  }
}
