import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth_user_changes.g.dart';

@riverpod

/// fired when update email/password/phoneNum/displayName/photoURL
Stream<User?> authInfoChanges(Ref ref) => FirebaseAuth.instance.userChanges();
