// TODO: compare to other providers later when using it

// 

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

//   factory Notification.fromRTDB(dynamic doc) {
//     Map<String, dynamic> data = {};
//     if (doc.value != null) {
//       data = doc.value as Map<String, dynamic>;
//     }

//     return Notification(
//       id: doc.key,
//       title: data['title'] ?? '',
//       message: data['message'] ?? '',
//       createdAt: data['createdAt'] == null ? null :(data['createdAt'] as ServerValue.timestamp).toDate(),
//     );
//   }
// Map<String, dynamic> toJSON() {
//     Map<String, dynamic> toJSONMap = {};
//     if (createdAt != null) {
//       toJSONMap.addAll({'backgroundMusic': ServerValue.timestamp.fromDate(createdAt!)});
//     }
//     if (displayName != null) {
//       toJSONMap.addAll({'backgroundMusic': displayName});
//     }
//     if (phoneNum != null) {
//       toJSONMap.addAll({'backgroundMusic': phoneNum});
//     }
//     if (profilePicLink != null) {
//       toJSONMap.addAll({'backgroundMusic': profilePicLink});
//     }
//     if (isApproved != null) {
//       toJSONMap.addAll({'backgroundMusic': isApproved});
//     }
//     return toJSONMap;
//   }
// }
