import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:firebase_database/firebase_database.dart';

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

  factory Challenge.fromRTDB(DataSnapshot doc) {
    Map data = {};
    if (doc.value != null) {
      data = doc.value as Map;
    }

    return Challenge(
      id: doc.key,
      name: data['name'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      additionalInfo: data['additionalInfo'] ?? '',
      solutionMatch: data['solutionMatch'],
      limitations: data['limitations'] == null ? [] : (data['limitations'] as List<dynamic>).map((i) => i as String).toList(),
      blocks: data['blocks'] == null
          ? null
          : (data['blocks'] as Map<Object?, Object?>).map<CodeBlockType, List<GameBlockData>>((key, value) {
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

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (additionalInfo != null) {
      toJSONMap.addAll({'additionalInfo': additionalInfo});
    }
    if (blocks != null) {
      final blocksMap = blocks!.map((key, value) {
        return MapEntry(key.name, value.map((data) => data.toJSON()).toList());
      });
      toJSONMap.addAll({'blocks': blocksMap});
    }
    if (solutionMatch != null) {
      toJSONMap.addAll({'solutionMatch': solutionMatch});
    }
    if (difficulty != null) {
      toJSONMap.addAll({'difficulty': difficulty?.name});
    }
    if (limitations != null) {
      toJSONMap.addAll({'limitations': limitations});
    }
    if (name != null) {
      toJSONMap.addAll({'name': name});
    }
    if (shortDescription != null) {
      toJSONMap.addAll({'shortDescription': shortDescription});
    }
    if (tags != null) {
      toJSONMap.addAll({'tags': tags});
    }
    return toJSONMap;
  }
}
