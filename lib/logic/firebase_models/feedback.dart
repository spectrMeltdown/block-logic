import 'package:firebase_database/firebase_database.dart';

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

  factory FeedbackData.fromRTDB(DataSnapshot doc) {
    Map data = {};
    if (doc.value != null) {
      data = doc.value as Map;
    }

    return FeedbackData(
      id: doc.key,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      userID: data['userID'] ?? '',
      createdAt: data['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (createdAt != null) {
      toJSONMap.addAll({'createdAt': createdAt!.microsecondsSinceEpoch});
    }
    if (message != null) {
      toJSONMap.addAll({'message': message});
    }
    if (title != null) {
      toJSONMap.addAll({'title': title});
    }
    if (userID != null) {
      toJSONMap.addAll({'userID': userID});
    }
    return toJSONMap;
  }
}
