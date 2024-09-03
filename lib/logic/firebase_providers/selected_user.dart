import 'dart:async';

import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user.g.dart';

@riverpod
Stream<UserAccount?> selectedUser(SelectedUserRef ref, String id) async* {
  if (id.isNotEmpty) {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('users').doc(id).snapshots();
    await for (final doc in stream) {
      if (doc.exists) {
        yield UserAccount.fromFirestore(doc);
      } else {
        yield null;
      }
    }
  }
  yield null;
}
