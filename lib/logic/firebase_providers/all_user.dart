import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/all_user.g.dart';

@riverpod
Stream<List<UserAccount>> allUsers(AllUsersRef ref) async* {
  final db = FirebaseFirestore.instance;
  final users = db.collection('users').snapshots();
  final result = <UserAccount>[];
  await for (final userList in users) {
    if (userList.docs.isNotEmpty) {
      for (final user in userList.docs) {
        result.add(UserAccount.fromFirestore(user));
      }
    }
    yield result;
  }
}
