import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user.g.dart';

@Riverpod()
Stream<UserAccount?> selectedUser(SelectedUserRef ref, String id) async* {
  if (id.isEmpty) yield null;
  final db = FirebaseFirestore.instance;
  final stream = db.collection('users').doc(id).snapshots();
  await for (final doc in stream) {
    yield UserAccount.fromFirestore(doc);
  }
}
