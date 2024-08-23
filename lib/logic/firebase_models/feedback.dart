import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackData {
  final String? id;
  final String? title;
  final String? userID;
  final String? message;
  final DateTime? createdAt;
  FeedbackData({
    this.id,
    this.title,
    this.userID,
    this.message,
    this.createdAt,
  });

  factory FeedbackData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return FeedbackData(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      userID: data['userID'] ?? '',
      createdAt: data['createdAt'] == null
          ? null
          : (data['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore(FeedbackData feedback) {
    Map<String, dynamic> toFirestoreMap = {};
    if (feedback.createdAt != null) {
      toFirestoreMap.addAll({'createdAt': feedback.createdAt});
    }
    if (feedback.message != null) {
      toFirestoreMap.addAll({'message': feedback.message});
    }
    if (feedback.title != null) {
      toFirestoreMap.addAll({'title': feedback.title});
    }
    if (feedback.userID != null) {
      toFirestoreMap.addAll({'userID': feedback.userID});
    }
    return toFirestoreMap;
  }
}
