import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/checkpoint_web.g.dart';

@riverpod
Stream<AdminAccount?> checkPointAdmin(CheckPointAdminRef ref) async* {
  ref.watch(authChangesProvider);
  if (FirebaseAuth.instance.currentUser == null) {
    yield null;
  } else {
    final stream =
        FirebaseFirestore.instance.collection('admins').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    await for (final doc in stream) {
      yield AdminAccount.fromFirestore(doc);
    }
  }
}
