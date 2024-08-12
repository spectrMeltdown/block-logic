// TODO: compare to other providers later when using it

// import 'package:block_logic/logic/firebase_models/timestamp_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Report extends TimestampModel {
//   final String id;
//   final bool? reportType;
//   final String? data;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   Report({
//     required this.id,
//     this.reportType,
//     this.data,
//     this.startDate,
//     this.endDate,
//     super.createdAt,
//     super.modifiedAt,
//   });

//   factory Report.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = {};
//     if (doc.data() != null) {
//       data = doc.data() as Map<String, dynamic>;
//     }

//     return Report(
//       id: doc.id,
//       reportType: data['reportType'] ?? '',
//       data: data['data'] ?? '',
//       startDate: (data['startDate'] as Timestamp).toDate(),
//       endDate: (data['endDate'] as Timestamp).toDate(),
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
//     );
//   }
//   Map<String, dynamic> toFirestore(Report report) {
//     Map<String, dynamic> toFirestoreMap = {};
//     if (report.createdAt != null) {
//       toFirestoreMap.addAll({'createdAt': report.createdAt});
//     }
//     if (report.modifiedAt != null) {
//       toFirestoreMap.addAll({'modifiedAt': report.modifiedAt});
//     }
//     if (report.data != null) {
//       toFirestoreMap.addAll({'data': report.data});
//     }
//     if (report.endDate != null) {
//       toFirestoreMap.addAll({'endDate': report.endDate});
//     }
//     if (report.startDate != null) {
//       toFirestoreMap.addAll({'startDate': report.startDate});
//     }

//     if (report.reportType != null) {
//       toFirestoreMap.addAll({'reportType': report.reportType});
//     }
//     return toFirestoreMap;
//   }
// }
