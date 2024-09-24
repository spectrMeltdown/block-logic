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
  final List<dynamic>? solutionMatch;
  final List<String>? tags;
  Challenge({
    this.id,
    this.name,
    this.shortDescription,
    this.additionalInfo,
    this.solutionMatch,
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
      shortDescription: data['shortDescription'] ?? '',
      additionalInfo: data['additionalInfo'] ?? '',
      solutionMatch: data['solutionMatch'],
      limitations: data['limitations'] == null ? [] : (data['limitations'] as List<dynamic>).map((i) => i as String).toList(),
      blocks: data['blocks'] == null
          ? null
          : (data['blocks'] as Map<String, dynamic>).map<CodeBlockType, List<GameBlockData>>((key, value) {
              // Convert the key to CodeBlockType
              CodeBlockType codeBlockType = CodeBlockType.values.firstWhere((e) => e.name == key);

              // Convert the value (List<dynamic>) to List<GameBlockData>
              List<GameBlockData> gameBlockDataList = (value as List<dynamic>).map((item) => GameBlockData.fromJSON(item)).toList();

              return MapEntry(codeBlockType, gameBlockDataList);
            }),
      difficulty: data['difficulty'] != null ? Difficulty.values.firstWhere((e) => e.name == data['difficulty']) : null,
      tags: data['tags'] == null ? [] : (data['tags'] as List<dynamic>).map((i) => i as String).toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (additionalInfo != null) {
      toFirestoreMap.addAll({'additionalInfo': additionalInfo});
    }
    if (blocks != null) {
      final blocksMap = blocks!.map((key, value) {
        return MapEntry(key.name, value.map((data) => data.toJSON()).toList());
      });
      toFirestoreMap.addAll({'blocks': blocksMap});
    }
    if (solutionMatch != null) {
      toFirestoreMap.addAll({'solutionMatch': solutionMatch});
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
