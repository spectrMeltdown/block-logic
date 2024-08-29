import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String? id;
  final String? name;
  final String? shortDescription;
  final String? additionalInfo;
  final Difficulty? difficulty;
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
    Difficulty? difficultyFirestore;
    if (data['difficulty'] != null) {
      switch (data['difficulty']) {
        case 'intermediate':
          difficultyFirestore = Difficulty.intermediate;
          break;
        case 'beginner':
          difficultyFirestore = Difficulty.beginner;
          break;
        case 'advanced':
          difficultyFirestore = Difficulty.advanced;
          break;
        default:
      }
    }

    return Challenge(
      id: doc.id,
      name: data['name'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      additionalInfo: data['additionalInfo'] ?? '',
      limitations:
          data['limitations'] == null ? [] : (data['limitations'] as List<dynamic>).map((i) => i as String).toList(),
      blocks: data['blocks'] == null
          ? null
          : data.map<CodeBlockType, List<GameBlockData>>((key, value) {
              // Convert the key to CodeBlockType
              CodeBlockType codeBlockType = CodeBlockType.values.firstWhere((e) => e.toString() == key.toString());

              // Convert the value (List<dynamic>) to List<GameBlockData>
              List<GameBlockData> gameBlockDataList = value.map((item) => GameBlockData.fromJson(item)).toList();

              return MapEntry(codeBlockType, gameBlockDataList);
            }),
      difficulty: difficultyFirestore,
      tags: data['tags'] == null ? [] : (data['tags'] as List<dynamic>).map((i) => i as String).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (additionalInfo != null) {
      toFirestoreMap.addAll({'additionalInfo': additionalInfo});
    }
    if (blocks != null) {
      toFirestoreMap.addAll({'blocks': {}});
    }
    if (difficulty != null) {
      toFirestoreMap.addAll({'difficulty': difficulty?.name});
    }
    if (limitations != null) {
      toFirestoreMap.addAll({'limitations': limitations});
    }
    if (name != null) {
      toFirestoreMap.addAll({'name': name});
    }
    if (shortDescription != null) {
      toFirestoreMap.addAll({'shortDescription': shortDescription});
    }
    if (tags != null) {
      toFirestoreMap.addAll({'tags': tags});
    }
    return toFirestoreMap;
  }
}
