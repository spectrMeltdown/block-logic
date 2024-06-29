import 'package:block_logic/logic/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DB {
  /// the database
  final FirebaseFirestore _db = FirebaseFirestore.instance;
}

/// All database interactions are found here
class DBService extends DB {
  /// Stream a document
  Stream<Admin> streamAdmin(String id) {
    return _db.collection('admins').doc(id).snapshots().map((doc) => Admin.fromFirestore(doc));
  }

  Stream<UserModel> streamUser(String id) {
    return _db.collection('users').doc(id).snapshots().map((doc) => UserModel.fromFirestore(doc));
  }

  Stream<Report> streamReport(String id) {
    return _db.collection('reports').doc(id).snapshots().map((doc) => Report.fromFirestore(doc));
  }

  Stream<Leaderboard> streamLeaderboard(String id) {
    return _db.collection('leaderboards').doc(id).snapshots().map((doc) => Leaderboard.fromFirestore(doc));
  }

  Stream<Score> streamScore(String id) {
    return _db.collection('scores').doc(id).snapshots().map((doc) => Score.fromFirestore(doc));
  }

  Stream<Challenge> streamChallenge(String id) {
    return _db.collection('challenges').doc(id).snapshots().map((doc) => Challenge.fromFirestore(doc));
  }

  Stream<FeedbackModel> streamFeedback(String id) {
    return _db.collection('feedback').doc(id).snapshots().map((doc) => FeedbackModel.fromFirestore(doc));
  }

  /// Write data
  Future<void> createReport(Report report) {
    return _db.collection('reports').doc(report.id).set(report.toFirestore());
  }

  /// Stream a sub-collection
  Stream<List<Score>> streamScores(String leaderboardID) {
    var ref = _db.collection('leaderboards').doc(leaderboardID).collection('scores');

    return ref.snapshots().map((list) => list.docs.map((doc) => Score.fromFirestore(doc)).toList());
  }
}
