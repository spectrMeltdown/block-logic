import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/auth_changes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns the user email as BLText
class BLEmail extends ConsumerWidget {
  final String? nullMessage;
  const BLEmail({this.nullMessage, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authInfoChangesProvider);
    return user.when(data: (user) => BLText(user?.email ?? nullMessage ?? ''), error: blankError, loading: blankLoading);
  }
}
