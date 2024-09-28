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

final reportsProvider = StreamProvider.family.autoDispose<Map<TimePeriod, Map<int, List<Report>>>, ReportParams>((ref, params) async* {
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
      yield groupReportsByTimePeriod(filteredList);
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

  for (final report in reports) {
    final createdAt = report.date!;

    // Group by yearly
    final year = createdAt.year;
    if (groupedReports[TimePeriod.yearly]?[year] == null) {
      groupedReports[TimePeriod.yearly]?[year] = [];
    }
    groupedReports[TimePeriod.yearly]?[year]?.add(report);

    // Group by monthly
    final monthKey = year * 100 + createdAt.month; // Unique key for each month
    if (groupedReports[TimePeriod.monthly]?[monthKey] == null) {
      groupedReports[TimePeriod.monthly]?[monthKey] = [];
    }
    groupedReports[TimePeriod.monthly]?[monthKey]?.add(report);

    // Group by weekly
    final startOfWeek = createdAt.subtract(Duration(days: createdAt.weekday - 1)); // Start of the week (Monday)
    final weekKey = year * 100 + startOfWeek.weekOfYear(); // Custom function to calculate week number
    if (groupedReports[TimePeriod.weekly]?[weekKey] == null) {
      groupedReports[TimePeriod.weekly]?[weekKey] = [];
    }
    groupedReports[TimePeriod.weekly]?[weekKey]?.add(report);

    // Group by daily
    final dayKey = year * 10000 + createdAt.month * 100 + createdAt.day; // Unique key for each day
    if (groupedReports[TimePeriod.daily]?[dayKey] == null) {
      groupedReports[TimePeriod.daily]?[dayKey] = [];
    }
    groupedReports[TimePeriod.daily]?[dayKey]?.add(report);
  }

  return groupedReports;
}

// Helper function to get the week number of the year
extension DateTimeExtension on DateTime {
  int weekOfYear() {
    final firstDayOfYear = DateTime(year, 1, 1);
    final daysSinceYearStart = difference(firstDayOfYear).inDays;
    return (daysSinceYearStart / 7).ceil(); // Approximate week number
  }
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
