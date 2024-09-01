// TODO: compare to other providers later when using it

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Notification {
//   final String id;
//   final String? title;
//   final String? message;
//   final DateTime? createdAt;
//   Notification({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.createdAt,
//   });

//   factory Notification.fromFirestore(dynamic doc) {
//     Map<String, dynamic> data = {};
//     if (doc.data() != null) {
//       data = doc.data() as Map<String, dynamic>;
//     }

//     return Notification(
//       id: doc.id,
//       title: data['title'] ?? '',
//       message: data['message'] ?? '',
//       createdAt: data['createdAt'] == null ? null :(data['createdAt'] as Timestamp).toDate(),
//     );
//   }
// Map<String, dynamic> toFirestore() {
//     Map<String, dynamic> toFirestoreMap = {};
//     if (createdAt != null) {
//       toFirestoreMap.addAll({'backgroundMusic': Timestamp.fromDate(createdAt!)});
//     }
//     if (displayName != null) {
//       toFirestoreMap.addAll({'backgroundMusic': displayName});
//     }
//     if (phoneNum != null) {
//       toFirestoreMap.addAll({'backgroundMusic': phoneNum});
//     }
//     if (profilePicLink != null) {
//       toFirestoreMap.addAll({'backgroundMusic': profilePicLink});
//     }
//     if (isApproved != null) {
//       toFirestoreMap.addAll({'backgroundMusic': isApproved});
//     }
//     return toFirestoreMap;
//   }
// }
