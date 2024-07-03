import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> account(AccountRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@Riverpod(keepAlive: true)
Stream<UserDetails?> userDetails(UserDetailsRef ref) {
  return DBService().streamUser(AuthService.getUID());
}

@Riverpod(keepAlive: true)
Stream<AdminDetails?> adminDetails(AdminDetailsRef ref) {
  return DBService().streamAdmin(AuthService.getUID());
}
