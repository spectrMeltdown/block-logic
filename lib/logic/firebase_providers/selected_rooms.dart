import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_rooms.g.dart';

@riverpod
Stream<List<Room>> selectedRooms(SelectedRoomsRef ref, String accountID, {String? searchQuery}) async* {
  if (accountID.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('rooms').equalTo(accountID).onValue;
    await for (final query in stream) {
      final List<Room> initData = [];
      final List<Room> result = [];
      if (query.snapshot.children.isNotEmpty) {
        for (final data in query.snapshot.children) {
          initData.add(Room.fromRTDB(data));
        }

        /// filter out the roooms when a searchQuery is provided
        if (searchQuery != null && searchQuery.isNotEmpty) {
          // Convert query to lowercase for case-insensitive matching
          final lowerCaseQuery = searchQuery.toLowerCase();

          // Filter and prioritize documents
          final filteredDocuments = initData.where((doc) {
            final fieldValue = initData.toString();
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
          for (final room in filteredDocuments) {
            result.add(room);
          }
        } else {
          for (final room in query.snapshot.children) {
            result.add(Room.fromRTDB(room));
          }
        }
      }

      /// remove rooms marked with admin lock
      result.removeWhere((room) {
        return room.adminLocked == true;
      });
      yield result;
    }
  } else {
    throw ('You did not provide accountID.');
  }
}
