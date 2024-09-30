import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_challenges.g.dart';

@riverpod
Stream<List<Challenge>> challenges(ChallengesRef ref, {String searchQuery = ''}) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('challenges').snapshots();
  await for (final query in stream) {
    final List<Challenge> result = [];
    if (query.docs.isNotEmpty) {
      if (query.docs.isNotEmpty) {
        /// filter out the roooms when a searchQuery is provided
        if (searchQuery.isNotEmpty) {
          // Convert query to lowercase for case-insensitive matching
          final lowerCaseQuery = searchQuery.toLowerCase();

          // Filter and prioritize documents
          final filteredDocuments = query.docs.where((doc) {
            final fieldValue = doc['name'].toString();
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
            final aValue = a['name'].toString();
            final bValue = b['name'].toString();
            final lowerCaseAValue = aValue.toLowerCase();
            final lowerCaseBValue = bValue.toLowerCase();

            if (lowerCaseAValue == lowerCaseQuery) return -1;
            if (lowerCaseBValue == lowerCaseQuery) return 1;

            if (lowerCaseAValue.contains(lowerCaseQuery)) return -1;
            if (lowerCaseBValue.contains(lowerCaseQuery)) return 1;

            return 0; // Default ordering if no match
          });
          for (final doc in filteredDocuments) {
            result.add(Challenge.fromFirestore(doc));
          }
        } else {
          for (final room in query.docs) {
            result.add(Challenge.fromFirestore(room));
          }
        }
      }
      for (final queryDoc in query.docs) {
        result.add(Challenge.fromFirestore(queryDoc));
      }
    }
    yield result;
  }
}
