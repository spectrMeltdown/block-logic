import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/login_check.g.dart';

@riverpod
Future<String?> loginCheck(LoginCheckRef ref) async {
  final account = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
  return UserAccount.fromFirestore(account).sessionID;
}
