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
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//     );
//   }
// Map<String, dynamic> toFirestore(AdminAccount admin) {
//     Map<String, dynamic> toFirestoreMap = {};
//     if (admin.createdAt != null) {
//       toFirestoreMap.addAll({'backgroundMusic': admin.createdAt});
//     }
//     if (admin.displayName != null) {
//       toFirestoreMap.addAll({'backgroundMusic': admin.displayName});
//     }
//     if (admin.phoneNum != null) {
//       toFirestoreMap.addAll({'backgroundMusic': admin.phoneNum});
//     }
//     if (admin.profilePicLink != null) {
//       toFirestoreMap.addAll({'backgroundMusic': admin.profilePicLink});
//     }
//     if (admin.isApproved != null) {
//       toFirestoreMap.addAll({'backgroundMusic': admin.isApproved});
//     }
//     return toFirestoreMap;
//   }
// }
