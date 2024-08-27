import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Score {
  final String? id;
  final String? accountID;
  final int? playerScore;
  final int? timeElapsed;
  final int? rank;
  final ScoreStatus? status;
  Score({
    this.id,
    this.accountID,
    this.playerScore,
    this.timeElapsed,
    this.rank,
    this.status,
  });

  factory Score.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Score(
      id: doc.id,
      accountID: data['accountID'],
      playerScore: data['playerScore'],
      timeElapsed: data['timeElapsed'],
      rank: data['rank'],
      status: data['status'],
    );
  }
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (accountID != null) {
      toFirestoreMap.addAll({'accountID': accountID});
    }
    if (playerScore != null) {
      toFirestoreMap.addAll({'playerScore': playerScore});
    }
    if (rank != null) {
      toFirestoreMap.addAll({'rank': rank});
    }
    if (status != null) {
      toFirestoreMap.addAll({'status': status});
    }
    if (timeElapsed != null) {
      toFirestoreMap.addAll({'timeElapsed': timeElapsed});
    }
    return toFirestoreMap;
  }
}
