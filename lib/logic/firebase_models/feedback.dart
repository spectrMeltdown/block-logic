import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

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

  factory FeedbackData.fromRTDB(Object? doc, [String? key]) {
    Map<String, dynamic> data = {};

    if (doc is Map<Object?, Object?>) {
      data = (doc).map((k, v) => MapEntry(k as String, v));
    } else if (doc is DataSnapshot && doc.value != null) {
      data = (doc.value as Map<Object?, Object?>).map((k, v) => MapEntry(k as String, v));
    } else {
      debugPrint('Unknown type!!');
    }

    return FeedbackData(
      id: doc is DataSnapshot && doc.key != null ? doc.key : key,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      userID: data['userID'] ?? '',
      createdAt: data['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (createdAt != null) {
      toJSONMap.addAll({'createdAt': createdAt!.millisecondsSinceEpoch});
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
