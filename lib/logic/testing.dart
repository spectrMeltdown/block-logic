library testing;

import 'dart:math';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void clearConsole() {
  debugPrint('\x1B[2J\x1B[0;0H'); // Clears terminal on some systems that support ANSI escape
}

final testingProvider = StateNotifierProvider.autoDispose<Testing, TestingState>((ref) {
  final errorHandler = ref.read(errorHandlerProvider.notifier);
  return Testing(errorHandler);
});

class TestingState {
  final ErrorHandler errorHandler;
  final db = FirebaseFirestore.instance;
  TestingState(this.errorHandler);
}

class Testing extends StateNotifier<TestingState> {
  Testing(ErrorHandler errorHandler) : super(TestingState(errorHandler));
  Future<String?> populateReports({required DateTimeRange dateRange, required int number}) async {
    if (number < 1) throw ('Cannot be less than 1!');
    try {
      for (int i = 0; i < number; i++) {
        await state.db.collection('reports').doc().set(Report(
              date: getRandomDateTime(DateTimeRange(start: dateRange.start, end: dateRange.end)),
              count: getRandomInt(1, 20),
              type: ReportType.values[getRandomInt(0, ReportType.values.length - 1)],
              isTest: true,
            ).toFirestore());
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
  // Ensure the start is before the end
  if (start.isAfter(end)) {
    throw ArgumentError("Start date must be before end date.");
  }

  // Get the difference between start and end in milliseconds
  int millisecondsBetween = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;

  // If the difference is zero or negative, return the start date
  if (millisecondsBetween <= 0) {
    return start;
  }

  // Generate a random number of milliseconds from 0 to millisecondsBetween
  int randomMilliseconds = Random().nextInt(millisecondsBetween);

  // Add the random milliseconds to the start date
  return start.add(Duration(milliseconds: randomMilliseconds));
}

int getRandomInt(int min, int max) {
  debugPrint('Passed getRandomInt');
  // Generate a random number between min (inclusive) and max (inclusive)
  return min + Random().nextInt(max - min + 1);
}
