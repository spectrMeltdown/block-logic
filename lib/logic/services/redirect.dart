import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/redirect.g.dart';

getWidget({
  required AsyncValue<AdminAccount?> adminFirestore,
  required AuthService auth,
  required DBService dbService,
}) {
  if (auth.isLoggedIn()) {
    if (!auth.isEmailVerified()) {
      /// go to email verification screen (after main menu finish building)
      return 'verify-email';
    }

    /// TODO: check if phone number was verified
    adminFirestore.when(
        data: (admin) {
          /// if not exists
          if (admin == null) {
            return '/unauthorized';
          }
          if (admin.isApproved == null || admin.isApproved == false) {
            return '/waiting-approval';
          }
        },
        error: genericError,
        loading: genericLoading);
  } else {
    return '/login';
  }
  return '/';
}

@riverpod
FutureOr<String> redirect(
  RedirectRef ref,
  AsyncValue<AdminAccount?> adminFirestore,
  AuthService auth,
) {
  final user = ref.watch(accountAuthProvider);
  final dbService = ref.watch(dBServiceProvider.notifier);
  return switch (user) {
    AsyncValue<User?>() => getWidget(
        auth: auth,
        adminFirestore: adminFirestore,
        dbService: dbService,
      )
  };
}
