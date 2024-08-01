import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String? name;
  final String? shortDescription;
  final String? additionalInfo;
  final String? difficulty;
  final List<String> limitations;
  final Map<CodeBlockType, List<GameBlockData>> blocks;
  final List<String> tags;
  final DateTime dateCreated;
  Challenge({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.additionalInfo,
    required this.limitations,
    required this.blocks,
    required this.difficulty,
    required this.tags,
    required this.dateCreated,
  });

  /// set as dynamic because it could be either DocumentSnapshot or QueryDocumentSnapshot
  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Challenge(
      id: doc.id,
      name: data['name'] ?? '',
      shortDescription: data['short_description'] ?? '',
      additionalInfo: data['additional_info'] ?? '',
      limitations: data['limitations'] ?? [],
      blocks: data['blocks'] ?? [],
      difficulty: data['difficulty'] ?? '',
      tags: data['tags'] ?? [],
      dateCreated: (data['date_created'] as Timestamp).toDate(),
    );
  }
}
