import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/firebase_providers/auth_changes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user phone num as BLText
class BLPhoneNum extends ConsumerWidget {
  const BLPhoneNum({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(accountAuthChangesProvider);
    return user.when(
        data: (user) => BLText(user?.phoneNumber ?? ''),
        error: (error, stackTrace) => const BlankWidget(),
        loading: () => const BlankWidget());
  }
}
