library testing;

import 'dart:math';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void clearConsole() {
  debugPrint('\x1B[2J\x1B[0;0H'); // Clears terminal on some systems that support ANSI escape
}

final testingProvider = StateNotifierProvider<Testing, TestingState>((ref) {
  final errorHandler = ref.read(errorHandlerProvider.notifier);
  return Testing(errorHandler);
});

class TestingState {
  final ErrorHandler errorHandler;
  final db = FirebaseDatabase.instance;
  TestingState(this.errorHandler);
}

class Testing extends StateNotifier<TestingState> {
  Testing(ErrorHandler errorHandler) : super(TestingState(errorHandler));

  Future<String?> populateReports({required DateTimeRange dateRange, required int number}) async {
    if (number < 1) throw ('Cannot be less than 1!');
    try {
      for (int i = 0; i < number; i++) {
        await state.db.ref('reports').push().set(Report(
              date: getRandomDateTime(DateTimeRange(start: dateRange.start, end: dateRange.end)),
              count: getRandomInt(1, 20),
              type: ReportType.values[getRandomInt(0, ReportType.values.length - 1)],
              isTest: true,
            ).toJSON());
      }
      return null;
    } catch (e) {
      return state.errorHandler.call(e, this);
    }
  }

  Future<String?> deleteReports() async {
    try {
      final query = await state.db.ref('reports').equalTo(true).get();
      if (query.children.isNotEmpty) {
        for (final doc in query.children) {
          await doc.ref.remove();
        }
      }
      return null;
    } catch (e) {
      return state.errorHandler.call(e, this);
    }
  }
}

DateTime getRandomDateTime(DateTimeRange range) {
  DateTime start = range.start;
  DateTime end = range.end;
  debugPrint('Passed getRandomDateTime');
  if (start.isAfter(end)) {
    throw ArgumentError('Start date must be before end date.');
  }

  late DateTime result;
  late DateTime monthAndYear;
  int year = start.year != end.year ? getRandomInt(start.year, end.year) : start.year;
  int month = start.month != end.month ? getRandomInt(start.month, end.month) : start.month;
  monthAndYear = DateTime(
    year,
    month + 1,
    1,
  );
  final lastDayOfMonth = monthAndYear.subtract(const Duration(days: 1));
  int day = start.day != end.day ? getRandomInt(start.day, lastDayOfMonth.day) : start.day;

  result = DateTime(year, month, day);
  debugPrint(DateFormat('dd, MMM, y').format(result));
  return result;
}

int getRandomInt(int min, int max) {
  debugPrint('Passed getRandomInt');
  // Generate a random number between min (inclusive) and max (inclusive)
  return min + Random().nextInt(max - min + 1);
}
