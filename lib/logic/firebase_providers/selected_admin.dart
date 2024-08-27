import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_admin.g.dart';

@riverpod
Stream<AdminAccount?> selectedAdmin(SelectedAdminRef ref, String id) async* {
  if (id.isEmpty) {
    yield null;
  } else {
    final db = FirebaseFirestore.instance;
    final stream = db.collection('admins').doc(id).snapshots();
    await for (final doc in stream) {
      if (doc.exists) {
        yield AdminAccount.fromFirestore(doc);
      } else {
        yield null;
      }
    }
  }
}
