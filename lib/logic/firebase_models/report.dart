import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String? id;
  final ReportType? type;
  final String? userUID; // used for deletion operations
  final String? dataUID; // leaderboards or rooms UID
  final int? count;
  final DateTime? date;
  final bool? isTest;
  Report({
    this.id,
    this.type,
    this.count,
    this.date,
    this.isTest,
    this.userUID,
    this.dataUID,
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
        case 'basicUsers':
          type = ReportType.basicUsers;
          break;
        case 'leaderboards':
          type = ReportType.leaderboards;
          break;
        default:
          throw ('No matching ReportType!');
      }
    }
    // reportType: data['reportType'] ?? '',
    // data: data['data'] ?? '',
    // startDate: (data['startDate'] as Timestamp).toDate(),
    // endDate: (data['endDate'] as Timestamp).toDate(),
    // createdAt: data['createdAt'] == null ? null : (data['createdAt'] as Timestamp).toDate(),
    // modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    return Report(
      id: doc.id,
      count: data['count'],
      type: type,
      date: data['date'] == null ? null : (data['date'] as Timestamp).toDate(),
      isTest: data['isTest'],
      userUID: data['userUID'],
      dataUID: data['dataUID'],
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
    if (isTest != null) {
      toFirestoreMap.addAll({'isTest': isTest});
    }
    if (userUID != null) {
      toFirestoreMap.addAll({'userUID': userUID});
    }
    if (dataUID != null) {
      toFirestoreMap.addAll({'dataUID': dataUID});
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
