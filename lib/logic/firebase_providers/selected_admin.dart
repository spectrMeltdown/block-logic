import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_admin.g.dart';

@Riverpod(dependencies: [])
Stream<AdminAccount?> selectedAdmin(SelectedAdminRef ref, String id) async* {
  final db = FirebaseFirestore.instance;
  if (id.isNotEmpty) {
    final stream = db.collection('admins').doc(id).snapshots();
    await for (final doc in stream) {
      if (doc.exists == false) {
        yield null;
      } else {
        yield AdminAccount.fromFirestore(doc);
      }
    }
  } else {
    yield null;
  }
}
