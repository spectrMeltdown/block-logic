import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_admin.g.dart';

@riverpod
Stream<List<AdminAccount>> allAdmins(AllAdminsRef ref) async* {
  final db = FirebaseDatabase.instance;
  final result = <AdminAccount>[];
  db.ref('admins').onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.exists) {
      if (snapshot.children.isNotEmpty) {
        for (final admin in snapshot.children) {
          result.add(AdminAccount.fromRTDB(admin));
        }
      }
    }
  });
  yield result;
}
