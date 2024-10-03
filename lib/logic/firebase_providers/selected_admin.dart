import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_admin.g.dart';

@riverpod
Stream<AdminAccount?> selectedAdmin(SelectedAdminRef ref, String id) async* {
  if (id.isEmpty) {
    yield null;
  } else {
    final db = FirebaseDatabase.instance;
    final stream = db.ref('admins/$id').onValue;
    await for (final doc in stream) {
      if (doc.snapshot.exists) {
        yield AdminAccount.fromRTDB(doc.snapshot);
      } else {
        yield null;
      }
    }
  }
}
