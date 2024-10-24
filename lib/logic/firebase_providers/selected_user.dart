import 'dart:async';

import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_user.g.dart';

@riverpod
Stream<UserAccount?> selectedUser(Ref ref, String id) async* {
  if (id.isNotEmpty) {
    final db = FirebaseDatabase.instance;
    final controller = StreamController<UserAccount?>();
    db.ref('users/$id').onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        controller.add(UserAccount.fromRTDB(snapshot));
      } else {
        controller.add(null);
      }
    });
    yield* controller.stream;
  }
}
