import 'dart:async';

import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod/riverpod.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_admin.g.dart';

@riverpod
Stream<AdminAccount?> selectedAdmin(Ref ref, String id) async* {
  if (id.isEmpty) {
    yield null;
  } else {
    final db = FirebaseDatabase.instance;
    final controller = StreamController<AdminAccount>();
    db.ref('admins/$id').onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        controller.add(AdminAccount.fromRTDB(snapshot.value));
      }
    });
    yield* controller.stream;
  }
}
