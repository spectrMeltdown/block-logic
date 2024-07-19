import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Notification.fromFirestore(dynamic doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    return Notification(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
