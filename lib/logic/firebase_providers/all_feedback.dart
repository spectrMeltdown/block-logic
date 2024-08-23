import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_feedback.g.dart';

@riverpod
Stream<List<FeedbackData>> allFeedback(AllFeedbackRef ref,
    [String? searchQuery]) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('feedback').snapshots();
  await for (final feedbacks in stream) {
    final List<FeedbackData> result = [];
    if (feedbacks.docs.isNotEmpty) {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Convert query to lowercase for case-insensitive matching
        final lowerCaseQuery = searchQuery.toLowerCase();

        // Filter and prioritize documents
        final filteredDocuments = feedbacks.docs.where((doc) {
          final fieldValue = doc['title'].toString();
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
          final aValue = a['title'].toString();
          final bValue = b['title'].toString();
          final lowerCaseAValue = aValue.toLowerCase();
          final lowerCaseBValue = bValue.toLowerCase();

          if (lowerCaseAValue == lowerCaseQuery) return -1;
          if (lowerCaseBValue == lowerCaseQuery) return 1;

          if (lowerCaseAValue.contains(lowerCaseQuery)) return -1;
          if (lowerCaseBValue.contains(lowerCaseQuery)) return 1;

          return 0; // Default ordering if no match
        });
        for (final doc in filteredDocuments) {
          result.add(FeedbackData.fromFirestore(doc));
        }
      } else {
        for (final feedback in feedbacks.docs) {
          result.add(FeedbackData.fromFirestore(feedback));
        }
      }
    }
    yield result;
  }
}
