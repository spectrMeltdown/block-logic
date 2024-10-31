import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth_changes.g.dart';

/// fired only when login/loggout
@riverpod
Stream<User?> authChanges(Ref ref) => FirebaseAuth.instance.authStateChanges();
