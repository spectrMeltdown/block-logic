import 'package:block_logic/logic/enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

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

  factory Report.fromRTDB(Object? doc, [String? key]) {
    Map<String, dynamic> data = {};

    if (doc is Map<Object?, Object?>) {
      data = (doc).map((k, v) => MapEntry(k as String, v));
    } else if (doc is DataSnapshot && doc.value != null) {
      data = (doc.value as Map<Object?, Object?>).map((k, v) => MapEntry(k as String, v));
    } else {
      debugPrint('Unknown type!!');
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
    // startDate: (data['startDate'] as ServerValue.timestamp).toDate(),
    // endDate: (data['endDate'] as ServerValue.timestamp).toDate(),
    // createdAt: data['createdAt'] == null ? null : (data['createdAt'] as ServerValue.timestamp).toDate(),
    // modifiedAt: (data['modifiedAt'] as ServerValue.timestamp).toDate(),
    return Report(
      id: doc is DataSnapshot && doc.key != null ? doc.key : key,
      count: data['count'],
      type: type,
      date: data['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(data['date']),
      isTest: data['isTest'],
      userUID: data['userUID'],
      dataUID: data['dataUID'],
    );
  }
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> toJSONMap = {};
    if (date != null) {
      toJSONMap.addAll({'date': date!.millisecondsSinceEpoch});
    }
    if (type != null) {
      toJSONMap.addAll({'type': type!.name});
    }
    if (count != null) {
      toJSONMap.addAll({'count': count});
    }
    if (isTest != null) {
      toJSONMap.addAll({'isTest': isTest});
    }
    if (userUID != null) {
      toJSONMap.addAll({'userUID': userUID});
    }
    if (dataUID != null) {
      toJSONMap.addAll({'dataUID': dataUID});
    }
    // if (createdAt != null) {
    //   toJSONMap.addAll({'createdAt': ServerValue.timestamp.fromDate(createdAt!)});
    // }
    // if (modifiedAt != null) {
    //   toJSONMap.addAll({'modifiedAt': modifiedAt});
    // }
    // if (data != null) {
    //   toJSONMap.addAll({'data': data});
    // }
    // if (endDate != null) {
    //   toJSONMap.addAll({'endDate': endDate});
    // }
    // if (startDate != null) {
    //   toJSONMap.addAll({'startDate': startDate});
    // }

    // if (reportType != null) {
    //   toJSONMap.addAll({'reportType': reportType});
    // }
    return toJSONMap;
  }
}
