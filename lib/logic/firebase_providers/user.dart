import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user.g.dart';

@Riverpod()
Stream<UserAccount?> userAccount(UserAccountRef ref, String id) async* {
  final db = ref.watch(dbProvider).i;
  final stream = db.collection('users').doc(id).snapshots();
  await for (final doc in stream) {
    yield id.isEmpty ? null : UserAccount.fromFirestore(doc);
  }
}

@Riverpod(dependencies: [])
Stream<String?> userProfilePic(UserProfilePicRef ref, String id) async* {
  final userAccount = await ref.watch(UserAccountProvider(id).future);
  yield userAccount?.profilePicLink;
}

@Riverpod(dependencies: [])
Stream<String?> userDisplayName(UserDisplayNameRef ref, String id) async* {
  final userAccount = await ref.watch(UserAccountProvider(id).future);
  yield userAccount?.displayName;
}
