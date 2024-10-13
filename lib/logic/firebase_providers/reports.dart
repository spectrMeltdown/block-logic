import 'dart:async';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

final reportsProvider = StreamProvider.family<Object, ReportParams>((ref, params) async* {
  final controller = StreamController<Object>();
  params.stream.listen((event) {
    final snapshot = event.snapshot;
    final List<Report> list = [];

    if (snapshot.children.isNotEmpty) {
      for (final report in snapshot.children) {
        list.add(Report.fromRTDB(report));
      }
      if (params.dateRange == null) {
        controller.add(list);
      } else {
        controller.add(groupReportsByTimePeriod(list.where((report) => report.date!.isAfter(params.dateRange!.start) && report.date!.isBefore(params.dateRange!.end)).toList()));
      }
    } else {
      controller.add({});
    }
  });
  yield* controller.stream;
});

Map<TimePeriod, Map<int, List<Report>>> groupReportsByTimePeriod(List<Report> reports) {
  if (reports.isEmpty) return {};
  final Map<TimePeriod, Map<int, List<Report>>> groupedReports = {
    TimePeriod.yearly: {},
    TimePeriod.monthly: {},
    TimePeriod.weekly: {},
    TimePeriod.daily: {},
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
    // final monthKey = year * 100 + createdAt.month;
    final monthKey = int.parse('$year${createdAt.month}');
    debugPrint(monthKey.toString());
    if (groupedReports[TimePeriod.monthly]?[monthKey] == null) {
      groupedReports[TimePeriod.monthly]?[monthKey] = [];
    }
    groupedReports[TimePeriod.monthly]?[monthKey]?.add(report);

    // Group by weekly
    // final startOfWeek = createdAt.subtract(Duration(days: createdAt.weekday - 1)); // Start of the week (Monday)
    // final weekKey = year * 100 + startOfWeek.weekOfYear(); // Custom function to calculate week number
    final weekKey = int.parse(createdAt.yearMonthWeekString());
    debugPrint(weekKey.toString());
    if (groupedReports[TimePeriod.weekly]?[weekKey] == null) {
      groupedReports[TimePeriod.weekly]?[weekKey] = [];
    }
    groupedReports[TimePeriod.weekly]?[weekKey]?.add(report);

    // Group by daily
    // final dayKey = year * 10000 + createdAt.month * 100 + createdAt.day; // Unique key for each day
    final dayKey = int.parse(DateFormat('yyyyMMdd').format(createdAt));
    debugPrint(dayKey.toString());
    if (groupedReports[TimePeriod.daily]?[dayKey] == null) {
      groupedReports[TimePeriod.daily]?[dayKey] = [];
    }
    groupedReports[TimePeriod.daily]?[dayKey]?.add(report);
  }

  return groupedReports;
}

extension DateTimeExtension on DateTime {
  int weekOfYear() {
    final firstDayOfYear = DateTime(year, 1, 1);
    final firstMonday = firstDayOfYear.add(Duration(days: (firstDayOfYear.weekday - 1) % 7));
    final daysSinceFirstMonday = difference(firstMonday).inDays;
    return (daysSinceFirstMonday / 7).ceil() + 1;
  }

  // Method to get a formatted string as "yearNum + monthNum + weekNum"
  String yearMonthWeekString() {
    final yearString = year.toString();
    final monthString = DateFormat('MM').format(this);
    final weekString = weekOfYear().toString().padLeft(2, '0');
    return yearString + monthString + weekString;
  }
}

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
