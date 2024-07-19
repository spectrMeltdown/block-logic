import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/firebase_providers/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user display name as BLText
class BLDisplayName extends ConsumerWidget {
  const BLDisplayName(this.accountID, {super.key});
  final String accountID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(UserAccountProvider(accountID));
    return user.when(
        data: (user) => BLText(user?.displayName ?? ''),
        error: (error, stackTrace) => const BlankWidget(),
        loading: () => const BlankWidget());
  }
}
