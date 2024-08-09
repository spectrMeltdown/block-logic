import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardWidgetItem extends ConsumerWidget {
  final int rank;
  final UserAccount user;
  final DateTime time;
  const LeaderboardWidgetItem({
    required this.rank,
    required this.user,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
