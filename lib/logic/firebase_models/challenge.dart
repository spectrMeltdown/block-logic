import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String? name;
  final String? description;
  final String? difficulty;
  final bool? isShared;
  final List<String> tags;
  final DateTime dateCreated;
  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.isShared,
    required this.tags,
    required this.dateCreated,
  });

  /// set as dynamic because it could be either DocumentSnapshot or QueryDocumentSnapshot
  factory Challenge.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Challenge(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      difficulty: data['difficulty'] ?? '',
      isShared: data['isShared'] ?? false,
      tags: data['tags'] ?? [],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }
}
