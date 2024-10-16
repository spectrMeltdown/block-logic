import 'dart:async';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportDate extends Equatable {
  final int? year;
  final int? month;
  final int? week;
  final int? day;

  const ReportDate({this.year, this.month, this.week, this.day});
  @override
  List<Object?> get props => [year, month, week, day];
}

class ReportParams extends Equatable {
  final Query stream;
  final DateTimeRange? dateRange;

  const ReportParams({
    required this.dateRange,
    required this.stream,
  });

  @override
  List<Object?> get props => [dateRange, stream];
}

final reportsProvider = StreamProvider.family.autoDispose<Object, ReportParams>((ref, params) async* {
  debugPrint('Updated params to ${params.dateRange.toString()}');
  yield* params.stream.onValue.map((event) {
    final snapshot = event.snapshot;
    final List<Report> list = [];

    // debugPrint('Updated params inside the stream listen');
    if (snapshot.children.isNotEmpty) {
      for (final report in snapshot.children) {
        list.add(Report.fromRTDB(report));
      }

      if (params.dateRange == null) {
        return list;
      } else {
        return groupReportsByTimePeriod(
          list.where((report) => report.date!.isAfter(params.dateRange!.start) && report.date!.isBefore(params.dateRange!.end)).toList(),
        );
      }
    } else {
      return {};
    }
  });
});

Map<TimePeriod, Map<ReportDate, List<Report>>> groupReportsByTimePeriod(List<Report> reports) {
  if (reports.isEmpty) return {};
  final Map<TimePeriod, Map<ReportDate, List<Report>>> groupedReports = {
    TimePeriod.yearly: {},
    TimePeriod.monthly: {},
    TimePeriod.weekly: {},
    TimePeriod.daily: {},
  };

  for (final report in reports) {
    final createdAt = report.date!;

    // Group by yearly
    final yearKey = ReportDate(year: createdAt.year);
    if (groupedReports[TimePeriod.yearly]?[yearKey] == null) {
      groupedReports[TimePeriod.yearly]?[yearKey] = [];
    }
    groupedReports[TimePeriod.yearly]?[yearKey]?.add(report);

    // Group by monthly
    // final monthKey = year * 100 + createdAt.month;
    final monthKey = ReportDate(year: yearKey.year, month: createdAt.month);
    // debugPrint(monthKey.toString());
    if (groupedReports[TimePeriod.monthly]?[monthKey] == null) {
      groupedReports[TimePeriod.monthly]?[monthKey] = [];
    }
    groupedReports[TimePeriod.monthly]?[monthKey]?.add(report);

    // Group by weekly
    final weekKey = ReportDate(year: yearKey.year, week: createdAt.weekOfYear());
    // debugPrint(weekKey.toString());
    if (groupedReports[TimePeriod.weekly]?[weekKey] == null) {
      groupedReports[TimePeriod.weekly]?[weekKey] = [];
    }
    groupedReports[TimePeriod.weekly]?[weekKey]?.add(report);

    // Group by daily
    final dayKey = ReportDate(year: yearKey.year, month: monthKey.month, day: createdAt.day);
    // debugPrint(dayKey.toString());
    if (groupedReports[TimePeriod.daily]?[dayKey] == null) {
      groupedReports[TimePeriod.daily]?[dayKey] = [];
    }
    groupedReports[TimePeriod.daily]?[dayKey]?.add(report);
  }
  // debugPrint(groupedReports.toString());
  return groupedReports;
}

extension DateTimeExtension on DateTime {
  int weekOfYear() {
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstMonday = firstDayOfYear.add(Duration(days: (firstDayOfYear.weekday - 1) % 7));
    final daysSinceFirstMonday = difference(firstMonday).inDays;
    return (daysSinceFirstMonday / 7).ceil() + 1;
  }
}

  // Method to get a formatted string as "yearNum + monthNum + weekNum"
  // String yearMonthWeekString() {
  //   final yearString = year.toString();
  //   final monthString = DateFormat('MM').format(this);
  //   final weekString = weekOfYear().toString().padLeft(2, '0');
  //   return '$yearString$monthString$weekString${.1}';
  // }
// // Helper function to calculate the week number in the year
// int _getWeekOfYear(DateTime date) {
//   // Get the first day of the year
//   DateTime firstDayOfYear = DateTime(date.year, 1, 1);

//   // Get the weekday of the first day of the year (ISO where Monday = 1, Sunday = 7)
//   int firstWeekDay = firstDayOfYear.weekday;

//   // Calculate the difference in days between the date and the first day of the year
//   int dayOfYear = date.difference(firstDayOfYear).inDays + 1;

//   // Adjust day of year for ISO week system (first week starts with Monday)
//   int adjustedDayOfYear = dayOfYear + (firstWeekDay - 1);

//   // Calculate the week number (ceiling to round up)
//   return (adjustedDayOfYear / 7).ceil();
// }

// @riverpod
// Stream<Map<TimePeriod, List<Report>>> reports(
//   ReportsRef ref, {
//   required ReportType type,
//   required DateTime? from,
//   required DateTime? to,
// }) async* {
//   final db = FirebaseDatabase.instance;
//   final stream = db.ref('reports').where('type', isEqualTo: type.name).onValue;
//   await for (final reports in stream) {
//     final List<Report> unfilteredList = [];
//     List<Report> filteredList = [];
//     if (reports.snapshot.children.isNotEmpty) {
//       for (final report in reports.snapshot.children) {
//         unfilteredList.add(Report.fromRTDB(report));
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
