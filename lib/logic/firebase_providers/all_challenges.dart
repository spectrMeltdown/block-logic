import 'dart:async';

import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_challenges.g.dart';

@riverpod
Stream<List<Challenge>> challenges(ChallengesRef ref, {String searchQuery = ''}) async* {
  final db = FirebaseDatabase.instance;
  final controller = StreamController<List<Challenge>>();
  db.ref('challenges').onValue.listen((event) {
    final snapshot = event.snapshot;
    final List<Challenge> result = [];
    if (snapshot.children.isNotEmpty) {
      final List<Challenge> initData = [];
      for (final doc in snapshot.children) {
        initData.add(Challenge.fromRTDB(doc));
      }

      /// filter out the roooms when a searchQuery is provided
      if (searchQuery.isNotEmpty) {
        // Convert query to lowercase for case-insensitive matching
        final lowerCaseQuery = searchQuery.toLowerCase();

        // Filter and prioritize documents
        final filteredDocuments = initData.where((challenge) {
          final fieldValue = challenge.name.toString();
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
          final aValue = a.name.toString();
          final bValue = b.name.toString();
          final lowerCaseAValue = aValue.toLowerCase();
          final lowerCaseBValue = bValue.toLowerCase();

          if (lowerCaseAValue == lowerCaseQuery) return -1;
          if (lowerCaseBValue == lowerCaseQuery) return 1;

          if (lowerCaseAValue.contains(lowerCaseQuery)) return -1;
          if (lowerCaseBValue.contains(lowerCaseQuery)) return 1;

          return 0; // Default ordering if no match
        });
        for (final challenge in filteredDocuments) {
          result.add(challenge);
        }
      } else {
        for (final room in snapshot.children) {
          result.add(Challenge.fromRTDB(room));
        }
      }
    }
    controller.add(result);
  });
  yield* controller.stream;
}
