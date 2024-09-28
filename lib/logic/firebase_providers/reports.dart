import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/reports.g.dart';

class ReportParams extends Equatable {
  // final DateTime? to;
  // final DateTime? from;
  final Stream stream;
  final DateTimeRange? dateRange;

  const ReportParams({
    // required this.to,
    // required this.from,
    required this.dateRange,
    required this.stream,
  });

  @override
  // List<Object?> get props => [to, from, type];
  List<Object?> get props => [dateRange, stream];
}

final reportsProvider = StreamProvider.family.autoDispose<Map<TimePeriod, List<Report>>, ReportParams>((ref, params) async* {
  await for (final query in params.stream) {
    final List<Report> unfilteredList = [];
    List<Report> filteredList = [];

    if (query.docs.isNotEmpty) {
      for (final report in query.docs) {
        unfilteredList.add(Report.fromFirestore(report));
      }
      if (params.dateRange == null) {
        filteredList = unfilteredList;
      } else {
        filteredList = unfilteredList.where((report) => report.date!.isAfter(params.dateRange!.start) && report.date!.isBefore(params.dateRange!.end)).toList();
      }
      // yield groupReportsByTimePeriod(filteredList);
    } else {
      yield {};
    }
  }
});

Map<TimePeriod, Map<int, List<Report>>> groupReportsByTimePeriod(List<Report> reports) {
  final Map<TimePeriod, Map<int, List<Report>>> groupedReports = {
    TimePeriod.yearly: {}, // get all years from 2024 - 2050
    TimePeriod.monthly: {}, // get all months from 2024 - 2050
    TimePeriod.weekly: {}, // get all weeks from 2024 - 2050
    TimePeriod.daily: {}, // get all days from 2024 - 2050
  };

  /// TODO:
  /// return a new map that has yearly reports,

  for (final report in reports) {
    final createdAt = report.date!;

    // Group by yearly
    if (groupedReports[TimePeriod.yearly]?[createdAt.year] == null) {
      // groupedReports[TimePeriod.yearly]?.add(report);
    }

    // Group by monthly
    if (createdAt.month == DateTime.now().month) {
      // groupedReports[TimePeriod.monthly]?.add(report);
    }

    // Group by weekly (assuming week starts on Sunday)
    final currentWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7));
    if (createdAt.isAfter(currentWeek)) {
      // groupedReports[TimePeriod.weekly]?.add(report);
    }

    // Group by daily
    if (createdAt.day == DateTime.now().day) {
      // groupedReports[TimePeriod.daily]?.add(report);
    }
  }

  return groupedReports;
}

// @riverpod
// Stream<Map<TimePeriod, List<Report>>> reports(
//   ReportsRef ref, {
//   required ReportType type,
//   required DateTime? from,
//   required DateTime? to,
// }) async* {
//   final db = FirebaseFirestore.instance;
//   final stream = db.collection('reports').where('type', isEqualTo: type.name).snapshots();
//   await for (final reports in stream) {
//     final List<Report> unfilteredList = [];
//     List<Report> filteredList = [];
//     if (reports.docs.isNotEmpty) {
//       for (final report in reports.docs) {
//         unfilteredList.add(Report.fromFirestore(report));
//       }
//       if (from == null || to == null) {
//         filteredList = unfilteredList;
//       } else {
//         for (final report in filteredList) {
//           if (report.date!.isAfter(from) && report.date!.isBefore(to)) {
//             filteredList.add(report);
//           }
//         }
//       }
//       yield groupReportsByTimePeriod(filteredList);
//     } else {
//       yield {};
//     }
//   }
// }
