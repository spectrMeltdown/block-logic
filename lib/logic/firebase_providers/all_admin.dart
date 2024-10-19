import 'dart:async';

import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_admin.g.dart';

@riverpod
Stream<List<AdminAccount>> allAdmins(AllAdminsRef ref, {String searchQuery = ''}) async* {
  final db = FirebaseDatabase.instance;
  final controller = StreamController<List<AdminAccount>>();
  final result = <AdminAccount>[];
  db.ref('admins').onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.exists && snapshot.children.isNotEmpty) {
      final List<AdminAccount> initData = [];
      for (final doc in snapshot.children) {
        initData.add(AdminAccount.fromRTDB(doc));
      }
      if (searchQuery.isNotEmpty) {
        final lowerCaseQuery = searchQuery.toLowerCase();
        final filteredDocuments = initData.where((admin) {
          final fieldValue = admin.displayName.toString();
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
        for (final admin in filteredDocuments) {
          result.add(admin);
        }
      } else {
        for (final admin in snapshot.children) {
          result.add(AdminAccount.fromRTDB(admin));
        }
      }
    }
    controller.add(result);
  });
  yield* controller.stream;
}
