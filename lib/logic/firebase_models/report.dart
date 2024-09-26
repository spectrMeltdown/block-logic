import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String? id;
  final ReportType? type;
  final int? count;
  final DateTime? date;
  Report({
    this.id,
    this.type,
    this.count,
    this.date,
    // this.startDate,
    // this.endDate,
    // super.createdAt,
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }

    ReportType? type;
    if (data['type'] != null) {
      switch (data['type'] as String) {
        case 'users':
          type = ReportType.users;
          break;
        case 'rooms':
          type = ReportType.rooms;
          break;
        case 'challengesPlayed':
          type = ReportType.challengesPlayed;
          break;
        case 'roomsPlayed':
          type = ReportType.roomsPlayed;
          break;
        case 'premiumUsers':
          type = ReportType.premiumUsers;
          break;
        case 'freeUsers':
          type = ReportType.freeUsers;
          break;
        default:
          throw ('No matching ReportType!');
      }
    }
    return Report(
      id: doc.id, count: data['count'], type: type, date: data['date'] == null ? null : (data['date'] as Timestamp).toDate(),
      // reportType: data['reportType'] ?? '',
      // data: data['data'] ?? '',
      // startDate: (data['startDate'] as Timestamp).toDate(),
      // endDate: (data['endDate'] as Timestamp).toDate(),
      // createdAt: data['createdAt'] == null ? null : (data['createdAt'] as Timestamp).toDate(),
      // modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> toFirestoreMap = {};
    if (date != null) {
      toFirestoreMap.addAll({'date': Timestamp.fromDate(date!)});
    }
    if (type != null) {
      toFirestoreMap.addAll({'type': type!.name});
    }
    if (count != null) {
      toFirestoreMap.addAll({'count': count});
    }
    // if (createdAt != null) {
    //   toFirestoreMap.addAll({'createdAt': Timestamp.fromDate(createdAt!)});
    // }
    // if (modifiedAt != null) {
    //   toFirestoreMap.addAll({'modifiedAt': modifiedAt});
    // }
    // if (data != null) {
    //   toFirestoreMap.addAll({'data': data});
    // }
    // if (endDate != null) {
    //   toFirestoreMap.addAll({'endDate': endDate});
    // }
    // if (startDate != null) {
    //   toFirestoreMap.addAll({'startDate': startDate});
    // }

    // if (reportType != null) {
    //   toFirestoreMap.addAll({'reportType': reportType});
    // }
    return toFirestoreMap;
  }
}
