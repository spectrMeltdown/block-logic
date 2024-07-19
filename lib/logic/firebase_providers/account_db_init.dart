import 'package:block_logic/logic/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/account_db_init.g.dart';

/// a variant of streamUser, used to purposely get a null or non-null value from collection
@riverpod
Stream<bool> isAccountFirestoreInit(IsAccountFirestoreInitRef ref, String uid,
    FirestoreCollections accountCollection) async* {
  await for (DocumentSnapshot<Map<String, dynamic>> value in FirebaseFirestore
      .instance
      .collection(accountCollection.name)
      .doc(uid)
      .snapshots()) {
    yield value.exists;
  }
}
