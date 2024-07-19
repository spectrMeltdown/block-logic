import 'package:cloud_firestore/cloud_firestore.dart';

class Score {
  final String id;
  final int overallScore;
  final DateTime runTime;
  final int timeElapsed;
  final int rank;
  Score(
      {required this.id,
      required this.overallScore,
      required this.rank,
      required this.runTime,
      required this.timeElapsed});

  factory Score.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Score(
      id: doc.id,
      overallScore: data['overallScore'] ?? -1,
      rank: data['rank'] ?? -1,
      runTime: (data['runTime'] as Timestamp).toDate(),
      timeElapsed: data['timeElapsed'] ?? -1,
    );
  }
}
