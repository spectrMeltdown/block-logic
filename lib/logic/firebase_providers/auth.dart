import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth.g.dart';

/// fired only when login/loggout
@riverpod
Stream<User?> accountAuth(AccountAuthRef ref) =>
    FirebaseAuth.instance.authStateChanges();
