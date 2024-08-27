import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_admin.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user display name as BLText
class BLDisplayName extends ConsumerWidget {
  final String accountID;
  final AccountType type;
  final double? size;
  const BLDisplayName(this.accountID, this.type, {this.size, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (type == AccountType.admin) {
      final admin = ref.watch(SelectedAdminProvider(accountID));
      return admin.when(
          data: (admin) => BLText(
                admin?.displayName ?? '',
                size: kIsWeb ? 16 : size,
              ),
          error: blankError,
          loading: blankLoading);
    }
    final user = ref.watch(SelectedUserProvider(accountID));
    return user.when(
        data: (user) => BLText(
              user?.displayName ?? '--',
              size: kIsWeb ? 16 : size,
            ),
        error: blankError,
        loading: blankLoading);
  }
}
