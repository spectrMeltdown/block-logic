import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/auth_changes.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user phone num as BLText
class BLPhoneNum extends ConsumerWidget {
  const BLPhoneNum({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authData = ref.watch(authInfoChangesProvider); // phone number from FirebaseAuth
    return authData.when(
        data: (authData) {
          final user = ref.watch(SelectedUserProvider(authData?.uid ?? ''));
          return user.when(
              data: (user) {
                if (user != null) {
                  return BLText(user.phoneNum == null ? '' : '+63 ${user.phoneNum}');
                }
                return BLText(authData?.phoneNumber == null ? '' : '+63 ${authData!.phoneNumber}');
              },
              error: blankError,
              loading: blankLoading);
        },
        error: blankError,
        loading: blankLoading);
  }
}
