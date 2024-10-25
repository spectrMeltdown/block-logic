import 'package:block_logic/logic/dev.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackData {
  final String? id;
  final String? title;
  final String? userID;
  final String? message;
  final DateTime? createdOn;
  FeedbackData({
    this.id,
    this.title,
    this.userID,
    this.message,
    this.createdOn,
  });

  factory FeedbackData.fromRTDB(Object? doc, [String? key]) {
    Map<String, dynamic> data = {};

    if (doc is Map<Object?, Object?>) {
      data = (doc).map((k, v) => MapEntry(k as String, v));
    } else if (doc is DataSnapshot && doc.value != null) {
      data = (doc.value as Map<Object?, Object?>).map((k, v) => MapEntry(k as String, v));
    } else {
      dPrint('Unknown type!!');
    }

    return FeedbackData(
      id: doc is DataSnapshot && doc.key != null ? doc.key : key,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      userID: data['userID'] ?? '',
      createdOn: data['createdOn'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['createdOn']),
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (createdOn != null) {
      toJSONMap.addAll({'createdOn': createdOn!.millisecondsSinceEpoch});
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
