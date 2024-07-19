import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth_changes.g.dart';

@riverpod

/// fired when update email/password/phoneNum/displayName/photoURL
Stream<User?> accountAuthChanges(AccountAuthChangesRef ref) {
  return FirebaseAuth.instance.userChanges();
}
