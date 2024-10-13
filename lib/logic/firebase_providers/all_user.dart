import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_user.g.dart';

@riverpod
Stream<List<UserAccount>> allUsers(AllUsersRef ref) async* {
  final db = FirebaseDatabase.instance;
  final result = <UserAccount>[];
  db.ref('users').onValue.listen((event) {
    final snapshot = event.snapshot;
    if (snapshot.exists) {
      if (snapshot.children.isNotEmpty) {
        for (final user in snapshot.children) {
          result.add(UserAccount.fromRTDB(user));
        }
      }
    }
  });
  yield result;
}
