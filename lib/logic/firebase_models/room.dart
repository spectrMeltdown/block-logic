import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String? id;
  final String? hostID;
  final List<String> challengeIDs;
  final String? icon;
  final String? name;
  final String? password;
  final int? capacity;
  Room(
      {required this.id,
      required this.icon,
      required this.hostID,
      required this.challengeIDs,
      required this.name,
      required this.password,
      required this.capacity});

  // TODO: follow to other providers
  /// When calling this with [QueryDocumentSnapshot], cast it to [DocumentSnapshot]
  factory Room.fromFirestore(DocumentSnapshot doc) {
    return Room(
      id: doc.id,
      icon: doc.get('icon') ?? '',
      hostID: doc.get('hostID') ?? '',
      challengeIDs: (doc.get('challengeIDs') as List)
          .map((item) => item as String)
          .toList(), // Transform the List<dynamic> from Firestore to a List<String>
      name: doc.get('name') ?? '',
      password: doc.get('password') ?? '',
      capacity: doc.get('capacity') ?? -1,
    );
  }
}
