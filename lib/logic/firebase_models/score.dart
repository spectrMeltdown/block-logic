import 'package:block_logic/logic/enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Score {
  final String? id;
  final String? accountID;
  final int? playerScore; // refers to how many challenges they got correct
  final int? timeElapsed;
  // final int? rank;
  final ScoreStatus? status;
  Score({
    this.id,
    this.accountID,
    this.playerScore,
    this.timeElapsed,
    // this.rank,
    this.status,
  });

  factory Score.fromRTDB(Object? doc, [String? key]) {
    Map<String, dynamic> data = {};

    if (doc is Map<Object?, Object?>) {
      data = (doc).map((k, v) => MapEntry(k as String, v));
    } else if (doc is DataSnapshot && doc.value != null) {
      data = (doc.value as Map<Object?, Object?>).map((k, v) => MapEntry(k as String, v));
    } else {
      debugPrint('Unknown type!!');
    }

    ScoreStatus? status;
    if (data['status'] != null) {
      switch (data['status']) {
        case 'pending':
          status = ScoreStatus.pending;
          break;
        case 'incomplete':
          status = ScoreStatus.incomplete;
          break;
        case 'complete':
          status = ScoreStatus.complete;
          break;
        default:
      }
    }

    return Score(
      id: doc is DataSnapshot && doc.key != null ? doc.key : key,
      accountID: data['accountID'],
      playerScore: data['playerScore'],
      timeElapsed: data['timeElapsed'],
      status: status,
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (accountID != null) {
      toJSONMap.addAll({'accountID': accountID});
    }
    if (playerScore != null) {
      toJSONMap.addAll({'playerScore': playerScore});
    }
    if (status != null) {
      toJSONMap.addAll({'status': status!.name});
    }
    if (timeElapsed != null) {
      toJSONMap.addAll({'timeElapsed': timeElapsed});
    }
    return toJSONMap;
  }
}
