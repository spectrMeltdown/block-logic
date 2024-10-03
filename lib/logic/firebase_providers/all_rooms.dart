import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_rooms.g.dart';

@riverpod
Stream<List<Room>> rooms(RoomsRef ref, {String? searchQuery, String? uid}) async* {
  final db = FirebaseDatabase.instance;
  final stream = db.ref('rooms').onValue;
  await for (final query in stream) {
    final List<Room> result = [];
    if (query.snapshot.children.isNotEmpty) {
      final List<Room> initData = [];
      for (final doc in query.snapshot.children) {
        initData.add(Room.fromRTDB(doc));
      }

      /// filter out the roooms when a searchQuery is provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Convert query to lowercase for case-insensitive matching
        final lowerCaseQuery = searchQuery.toLowerCase();

        // Filter and prioritize documents
        final filteredDocuments = initData.where((room) {
          final fieldValue = room.name;
          final lowerCaseValue = fieldValue!.toLowerCase();

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
          final aValue = a.name!;
          final bValue = b.name!;
          final lowerCaseAValue = aValue.toLowerCase();
          final lowerCaseBValue = bValue.toLowerCase();

          if (lowerCaseAValue == lowerCaseQuery) return -1;
          if (lowerCaseBValue == lowerCaseQuery) return 1;

          if (lowerCaseAValue.contains(lowerCaseQuery)) return -1;
          if (lowerCaseBValue.contains(lowerCaseQuery)) return 1;

          return 0; // Default ordering if no match
        });
        for (final room in filteredDocuments) {
          result.add(room);
        }
      } else {
        for (final room in query.snapshot.children) {
          result.add(Room.fromRTDB(room));
        }
      }
    }

    if (!kIsWeb) {
      /// remove rooms marked with admin lock
      result.removeWhere((room) {
        return room.adminLocked == true;
      });

      /// remove own rooms
      if (uid != null && uid.isNotEmpty) {
        result.removeWhere((room) {
          return room.hostID == uid;
        });
      }
    }

    yield result;
  }
}
