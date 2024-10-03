import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_user.g.dart';

@riverpod
Stream<List<UserAccount>> allUsers(AllUsersRef ref) async* {
  final db = FirebaseDatabase.instance;
  final users = db.ref('users').onValue;
  await for (final userList in users) {
    final result = <UserAccount>[];
    if (userList.snapshot.children.isNotEmpty) {
      for (final user in userList.snapshot.children) {
        result.add(UserAccount.fromRTDB(user));
      }
    }
    yield result;
  }
}
