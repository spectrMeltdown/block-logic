import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user display name as BLText
class BLDisplayName extends ConsumerWidget {
  const BLDisplayName({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(accountChangesProvider);
    return user.when(
        data: (user) => BLText(user?.displayName ?? ''),
        error: (error, stackTrace) => blankWidget,
        loading: () => blankWidget);
  }
}

/// Returns the user email as BLText
class BLEmail extends ConsumerWidget {
  const BLEmail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(accountChangesProvider);
    return user.when(
        data: (user) => BLText(user?.email ?? ''),
        error: (error, stackTrace) => blankWidget,
        loading: () => blankWidget);
  }
}
