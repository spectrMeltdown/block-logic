import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user display name as BLText
class BLDisplayName extends ConsumerWidget {
  final String accountID;
  final double? size;
  const BLDisplayName(this.accountID, {this.size, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(SelectedUserProvider(accountID));
    return user.when(
        data: (user) => BLText(
              user?.displayName ?? '',
              size: kIsWeb ? 16 : size,
            ),
        error: (error, stackTrace) => const BlankWidget(),
        loading: () => const BlankWidget());
  }
}
