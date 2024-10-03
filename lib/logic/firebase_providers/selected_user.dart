import 'dart:async';

import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user.g.dart';

@riverpod
Stream<UserAccount?> selectedUser(SelectedUserRef ref, String id) async* {
  if (id.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('users/$id').onValue;
    await for (final doc in stream) {
      if (doc.snapshot.exists) {
        yield UserAccount.fromRTDB(doc.snapshot);
      } else {
        yield null;
      }
    }
  }
}
