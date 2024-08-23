import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_rooms.g.dart';

@riverpod
Stream<List<Room>> rooms(RoomsRef ref, [String? searchQuery]) async* {
  final db = FirebaseFirestore.instance;
  final roomsStream = db.collection('rooms').snapshots();
  await for (final rooms in roomsStream) {
    final List<Room> result = [];
    if (rooms.docs.isNotEmpty) {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Convert query to lowercase for case-insensitive matching
        final lowerCaseQuery = searchQuery.toLowerCase();

        // Filter and prioritize documents
        final filteredDocuments = rooms.docs.where((doc) {
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
          result.add(Room.fromFirestore(doc));
        }
      } else {
        for (final room in rooms.docs) {
          result.add(Room.fromFirestore(room));
        }
      }
    }
    yield result;
  }
}
