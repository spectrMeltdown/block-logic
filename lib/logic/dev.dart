library;

import 'dart:math';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/game/logic/all_blocks.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void clearConsole() {
  debugPrint('\x1B[2J\x1B[0;0H'); // Clears terminal on some systems that support ANSI escape
}

void dPrint(String? obj) {
  if (kDebugMode) debugPrint(obj);
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
      final query = await state.db.ref('reports').orderByChild('isTest').equalTo(true).get();
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
  // dPrint('Passed getRandomDateTime');
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
  dPrint(DateFormat('dd, MMM, y').format(result));
  return result;
}

int getRandomInt(int min, int max) {
  // dPrint('Passed getRandomInt');
  // Generate a random number between min (inclusive) and max (inclusive)
  return min + Random().nextInt(max - min + 1);
}

void populateChallenges() {
  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: '"Python is Awesome!"',
        shortDescription: 'Print "Python is Awesome!"',
        additionalInfo: 'Similar to "Hello, World" challenge. Involves printing, variables, and string concatenation.',
        blocks: AllBlocks().pythonIsAwesome(),
        difficulty: Difficulty.beginner,
        solutionMatch: ['Python is Awesome!'],
      ).toJSON());
  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Count characters',
        shortDescription: 'Write a program that assigns a string and counts how many characters it contains.',
        additionalInfo: 'Involves loops and string manipulation.',
        blocks: AllBlocks().countChars(),
        difficulty: Difficulty.beginner,
        solutionMatch: ['The string has 6 characters.'],
      ).toJSON());
  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Sum of two numbers',
        shortDescription: 'Write a program that assigns two numbers and outputs their sum.',
        additionalInfo: 'Involves simple arithmetic operations in Python.',
        blocks: AllBlocks().sumOfTwoNumbers(),
        difficulty: Difficulty.beginner,
        solutionMatch: ['The sum is: 15'],
      ).toJSON());
  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Odd or Even?',
        shortDescription: 'Write a program that assigns a number and checks if the number is odd or even.',
        additionalInfo: 'If the number is divisible by 2 with no remainder, it\'s even; otherwise, it\'s odd.',
        blocks: AllBlocks().oddOrEven(),
        difficulty: Difficulty.beginner,
        solutionMatch: ['The number is odd.', 'The number is even.'],
      ).toJSON());
  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: '"Hello, World!"',
        shortDescription: 'Print the string "Hello, World!" to the console.',
        additionalInfo: 'Simple printing in Python.',
        blocks: AllBlocks().helloWorld(),
        difficulty: Difficulty.beginner,
        solutionMatch: ['Hello, World!'],
      ).toJSON());

  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Prime Number Check',
        shortDescription: 'Write a program that checks if a given positive integer n is a prime number. A prime number is a number greater than 1 that is divisible only by 1 and itself.',
        additionalInfo: 'For example, 7 is a prime number, but 10 is not because it is divisible by 2 and 5.',
        blocks: AllBlocks().primeNumCheck(),
        difficulty: Difficulty.intermediate,
        solutionMatch: [true],
      ).toJSON());

  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Sum of first N natural Numbers',
        shortDescription: 'Write a program that calculates the sum of the first n natural numbers.',
        additionalInfo: ' The sum of the first n natural numbers is given by the formula n * (n + 1) / 2. For example, if n = 10, the sum is 1 + 2 + ... + 10 = 55.',
        blocks: AllBlocks().sumOfNaturalNumbers(),
        difficulty: Difficulty.intermediate,
        solutionMatch: [55],
      ).toJSON());

  FirebaseDatabase.instance.ref('challenges').push().set(
        Challenge(
          name: 'Palindrome',
          shortDescription: 'Write a program that checks if a given string is a palindrome.',
          additionalInfo: 'A palindrome is a word, phrase, or sequence that reads the same forwards as it does backwards. Ignore case. For example, the string "madam" is a palindrome, but "hello" is not.',
          blocks: AllBlocks().palindromeCheck(),
          difficulty: Difficulty.intermediate,
          solutionMatch: [true],
        ).toJSON(),
      );

  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Factorial',
        shortDescription: 'Given a positive integer n, write a program to compute the factorial of n.',
        additionalInfo: 'The factorial of a number is the product of all positive integers from 1 to n. For example, 5! = 5 * 4 * 3 * 2 * 1 = 120.',
        blocks: AllBlocks().factorial(),
        difficulty: Difficulty.intermediate,
        solutionMatch: [120],
      ).toJSON());

  FirebaseDatabase.instance.ref('challenges').push().set(Challenge(
        name: 'Sum of digits',
        shortDescription: 'Given a positive integer n, write a program to calculate the sum of its digits.',
        additionalInfo: ' For example, if n = 123, the sum of its digits is 1 + 2 + 3 = 6.',
        blocks: AllBlocks().sumOfDigits(),
        difficulty: Difficulty.intermediate,
        solutionMatch: [6],
      ).toJSON());
}
