import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/admin.g.dart';

@Riverpod()
Stream<AdminAccount?> adminAccount(AdminAccountRef ref, String id) async* {
  final db = ref.watch(dbProvider).i;
  final stream = db.collection('admins').doc(id).snapshots();
  await for (final doc in stream) {
    yield id.isEmpty ? null : AdminAccount.fromFirestore(doc);
  }
}

@Riverpod(dependencies: [])
Stream<String?> adminProfilePic(AdminProfilePicRef ref, String id) async* {
  final adminAccount = await ref.watch(AdminAccountProvider(id).future);
  yield adminAccount?.profilePicLink;
}

@Riverpod(dependencies: [])
Stream<String?> adminDisplayName(AdminDisplayNameRef ref, String id) async* {
  final adminAccount = await ref.watch(AdminAccountProvider(id).future);
  yield adminAccount?.displayName;
}
