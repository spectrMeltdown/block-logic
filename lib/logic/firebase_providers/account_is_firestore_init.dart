// import 'package:block_logic/logic/enums.dart';

// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/account_is_firestore_init.g.dart';

// a variant of streamUser, used to purposely get a null or non-null value from collection
// @riverpod
// Stream<bool> isFirestoreInit(IsFirestoreInitRef ref, String uid, FirestoreCollections accountCollection) async* {
//   await for (DataSnapshot<Map<String, dynamic>> value in FirebaseDatabase.instance.ref(accountCollection.name).onValue) {
//     yield value.exists;
//   }
// }
