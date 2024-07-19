import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final String? id;
  final String? roomID;
  final List<String>? accountIDs;
  final DateTime? dateCreated;
  Leaderboard({
    required this.id,
    required this.roomID,
    required this.accountIDs,
    required this.dateCreated,
  });

  factory Leaderboard.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Leaderboard(
      id: doc.id,
      roomID: data['roomID'] ?? '',
      accountIDs: data['accountIDs'] ?? [],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }
}
