import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_users.g.dart';

@riverpod
Future<List<UserAccount>> selectedUsers(
  Ref ref,
  List<String> ids,
) async {
  dPrint('IDs were: $ids');
  if (ids.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final List<UserAccount> accounts = [];
    for (final id in ids) {
      final user = await db.ref('users/$id').get();
      accounts.add(UserAccount.fromRTDB(user));
    }
    return accounts;
  } else {
    return [];
  }
}
