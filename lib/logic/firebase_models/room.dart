import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String? hostID;
  final List<String>? challengeIDs;
  final String? icon;
  final String? name;
  final String? password;
  final int? playerCount;
  final int? maxPlayers;
  final bool? started;
  final bool? ended;
  Room({
    required this.id,
    this.icon,
    this.hostID,
    this.challengeIDs,
    this.name,
    this.playerCount,
    this.started,
    this.ended,
    this.password,
    this.maxPlayers,
  });

  /// When calling this with [QueryDocumentSnapshot], cast it to [DocumentSnapshot]
  factory Room.fromFirestore(DocumentSnapshot doc) {
    return Room(
      id: doc.id,
      playerCount: doc.get('inRoom') ?? -1,
      started: doc.get('started'),
      ended: doc.get('ended'),
      icon: doc.get('icon') ?? '',
      hostID: doc.get('hostID') ?? '',
      challengeIDs: doc.get('challengeIDs') == null
          ? null
          : (doc.get('challengeIDs') as List)
              .map((item) => item as String)
              .toList(),
      name: doc.get('name') ?? '',
      password: doc.get('password'),
      maxPlayers: doc.get('capacity') ?? -1,
    );
  }
  Map<String, dynamic> toFirestore(Room room) {
    Map<String, dynamic> toFirestoreMap = {};
    if (room.challengeIDs != null) {
      toFirestoreMap.addAll({'challengeIDs': room.challengeIDs});
    }
    if (room.playerCount != null) {
      toFirestoreMap.addAll({'playerCount': room.playerCount});
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
    if (room.ended != null) {
      toFirestoreMap.addAll({'ended': room.ended});
    }
    if (room.started != null) {
      toFirestoreMap.addAll({'started': room.started});
    }
    return toFirestoreMap;
  }
}
