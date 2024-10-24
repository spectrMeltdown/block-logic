import 'dart:async';

import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_feedback.g.dart';

@riverpod
Stream<List<FeedbackData>> allFeedback(Ref ref, [String? searchQuery]) async* {
  final db = FirebaseDatabase.instance;
  final controller = StreamController<List<FeedbackData>>();
  db.ref('feedback').onValue.listen((event) {
    List<FeedbackData> result = [];
    final snapshot = event.snapshot;
    if (snapshot.exists) {
      if (snapshot.children.isNotEmpty) {
        final List<FeedbackData> initData = [];
        for (final doc in snapshot.children) {
          initData.add(FeedbackData.fromRTDB(doc));
        }
        if (searchQuery != null && searchQuery.isNotEmpty) {
          // Convert query to lowercase for case-insensitive matching
          final lowerCaseQuery = searchQuery.toLowerCase();

          // Filter and prioritize documents
          final filteredDocuments = initData.where((feedback) {
            final fieldValue = feedback.title.toString();
            final lowerCaseValue = fieldValue.toLowerCase();

            // Check for exact match
            if (lowerCaseValue == lowerCaseQuery) {
              return true;
            }

            // Check for partial match
            if (lowerCaseValue.contains(lowerCaseQuery)) {
              return true;
            }

            return false;
          }).toList();

          // Sort documents based on priority
          filteredDocuments.sort((a, b) {
            final aValue = a.title.toString();
            final bValue = b.title.toString();
            final lowerCaseAValue = aValue.toLowerCase();
            final lowerCaseBValue = bValue.toLowerCase();

            if (lowerCaseAValue == lowerCaseQuery) return -1;
            if (lowerCaseBValue == lowerCaseQuery) return 1;

            if (lowerCaseAValue.contains(lowerCaseQuery)) return -1;
            if (lowerCaseBValue.contains(lowerCaseQuery)) return 1;

            return 0; // Default ordering if no match
          });
          for (final feedback in filteredDocuments) {
            result.add(feedback);
          }
        } else {
          for (final feedback in snapshot.children) {
            result.add(FeedbackData.fromRTDB(feedback));
          }
        }
      }
    }
    controller.add(result);
  });

  yield* controller.stream;
}
