import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user.g.dart';

@Riverpod()
Stream<UserAccount?> userAccount(UserAccountRef ref, String id) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection('users').doc(id).snapshots();
  await for (final doc in stream) {
    yield id.isEmpty ? null : UserAccount.fromFirestore(doc);
  }
}

final userProfilePicProvider =
    StreamProvider.autoDispose.family<String?, String>((ref, id) async* {
  final userAcc = await ref.watch(UserAccountProvider(id).future);
  yield userAcc?.profilePicLink;
});

final userDisplayNameProvider =
    StreamProvider.autoDispose.family<String?, String>((ref, id) async* {
  final userAccount = await ref.watch(UserAccountProvider(id).future);
  yield userAccount?.displayName;
});
