import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/auth_user_changes.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user phone num as BLText
class BLPhoneNum extends ConsumerWidget {
  final String? nullMessage;
  const BLPhoneNum({this.nullMessage, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authData = ref.watch(authInfoChangesProvider); // phone number from FirebaseAuth
    return authData.when(
        data: (authData) {
          final user = ref.watch(SelectedUserProvider(authData?.uid ?? ''));
          return user.when(
              data: (user) {
                // if (user != null) {
                //   return BLText(null == null ? nullMessage ?? '' : '+63 ${user.phoneNum}');
                // }
                if (authData != null && authData.phoneNumber != null && authData.phoneNumber!.isNotEmpty) {
                  final firstSegment = authData.phoneNumber!.substring(0, 3);
                  final secondSegment = authData.phoneNumber!.substring(3, 6);
                  final thirdSegment = authData.phoneNumber!.substring(6, 9);
                  final fourthSegment = authData.phoneNumber!.substring(9, 13);
                  return BLText('$firstSegment $secondSegment $thirdSegment $fourthSegment');
                }
                return BLText(nullMessage ?? '');
              },
              error: blankError,
              loading: blankLoading);
        },
        error: blankError,
        loading: blankLoading);
  }
}
