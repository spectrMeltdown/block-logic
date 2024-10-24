import 'dart:async';

import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_user.g.dart';

@riverpod
Stream<List<UserAccount>> allUsers(Ref ref, {String searchQuery = ''}) async* {
  final db = FirebaseDatabase.instance;
  final controller = StreamController<List<UserAccount>>();
  final result = <UserAccount>[];
  db.ref('users').onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.exists && snapshot.children.isNotEmpty) {
      final List<UserAccount> initData = [];
      for (final doc in snapshot.children) {
        initData.add(UserAccount.fromRTDB(doc));
      }
      if (searchQuery.isNotEmpty) {
        final lowerCaseQuery = searchQuery.toLowerCase();
        final filteredDocuments = initData.where((user) {
          final fieldValue = user.displayName.toString();
          final lowerCaseValue = fieldValue.toLowerCase();

          if (lowerCaseValue == lowerCaseQuery) {
            return true;
          }
          if (lowerCaseValue.contains(lowerCaseQuery)) {
            return true;
          }

          return false;
        }).toList();
        filteredDocuments.sort((a, b) {
          final aValue = a.displayName.toString();
          final bValue = b.displayName.toString();
          final lowerCaseAValue = aValue.toLowerCase();
          final lowerCaseBValue = bValue.toLowerCase();

          if (lowerCaseAValue == lowerCaseQuery) return -1;
          if (lowerCaseBValue == lowerCaseQuery) return 1;

          if (lowerCaseAValue.contains(lowerCaseQuery)) return -1;
          if (lowerCaseBValue.contains(lowerCaseQuery)) return 1;

          return 0;
        });
        for (final user in filteredDocuments) {
          result.add(user);
        }
      } else {
        for (final user in snapshot.children) {
          result.add(UserAccount.fromRTDB(user));
        }
      }
    }
    controller.add(result);
  });
  yield* controller.stream;
}
