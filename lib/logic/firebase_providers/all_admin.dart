import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_admin.g.dart';

@riverpod
Stream<List<AdminAccount>> allAdmins(AllAdminsRef ref) async* {
  final db = FirebaseFirestore.instance;
  final admins = db.collection('admins').snapshots();
  final result = <AdminAccount>[];
  await for (final adminList in admins) {
    if (adminList.docs.isNotEmpty) {
      for (final admin in adminList.docs) {
        result.add(AdminAccount.fromFirestore(admin));
      }
    }
    yield result;
  }
}
