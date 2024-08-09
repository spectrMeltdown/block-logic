import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_users.g.dart';

@Riverpod()
Future<List<UserAccount>?> selectedUsers(
  SelectedUsersRef ref,
  List<String> ids,
) async {
  if (ids.isEmpty) return null;
  final db = FirebaseFirestore.instance;
  final List<UserAccount> accounts = [];
  for (final id in ids) {
    final user = await db.collection('users').doc(id).get();
    accounts.add(UserAccount.fromFirestore(user));
  }
  return accounts;
}
