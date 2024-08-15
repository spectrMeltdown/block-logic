import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String? id;
  final String? name;
  final String? shortDescription;
  final String? additionalInfo;
  final String? difficulty;
  final List<String>? limitations;
  final Map<CodeBlockType, List<GameBlockData>>? blocks;
  final List<String>? tags;
  Challenge({
    this.id,
    this.name,
    this.shortDescription,
    this.additionalInfo,
    this.limitations,
    this.blocks,
    this.difficulty,
    this.tags,
  });

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
    );
  }

  Map<String, dynamic> toFirestore(Challenge challenge) {
    Map<String, dynamic> toFirestoreMap = {};
    if (challenge.additionalInfo != null) {
      toFirestoreMap.addAll({'additionalInfo': challenge.additionalInfo});
    }
    if (challenge.blocks != null) {
      toFirestoreMap.addAll({
        'blocks': {CodeBlockType.classes.name: {}}
      });
    }
    if (challenge.difficulty != null) {
      toFirestoreMap.addAll({'difficulty': challenge.difficulty});
    }
    if (challenge.limitations != null) {
      toFirestoreMap.addAll({'limitations': challenge.limitations});
    }
    if (challenge.name != null) {
      toFirestoreMap.addAll({'name': challenge.name});
    }
    if (challenge.shortDescription != null) {
      toFirestoreMap.addAll({'shortDescription': challenge.shortDescription});
    }
    if (challenge.tags != null) {
      toFirestoreMap.addAll({'tags': challenge.tags});
    }
    return toFirestoreMap;
  }
}
