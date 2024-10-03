import 'package:block_logic/logic/firebase_models/user_account.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/login_check.g.dart';

@riverpod
Future<String?> loginCheck(LoginCheckRef ref) async {
  final account = await FirebaseDatabase.instance.ref('users').child(FirebaseAuth.instance.currentUser!.uid).get();
  return UserAccount.fromRTDB(account).sessionID;
}
