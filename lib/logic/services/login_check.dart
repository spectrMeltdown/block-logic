import 'package:block_logic/logic/firebase_models/user_account.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/login_check.g.dart';

@riverpod
Stream<String?> loginCheck(LoginCheckRef ref) async* {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final stream = FirebaseDatabase.instance.ref('users/$uid').onValue;
  await for (final doc in stream) {
    yield UserAccount.fromRTDB(doc.snapshot).sessionID;
  }
}
