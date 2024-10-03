import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_admin.g.dart';

@riverpod
Stream<List<AdminAccount>> allAdmins(AllAdminsRef ref) async* {
  final db = FirebaseDatabase.instance;
  final admins = db.ref('admins').onValue;
  final result = <AdminAccount>[];
  await for (final adminList in admins) {
    if (adminList.snapshot.children.isNotEmpty) {
      for (final admin in adminList.snapshot.children) {
        result.add(AdminAccount.fromRTDB(admin));
      }
    }
    yield result;
  }
}
