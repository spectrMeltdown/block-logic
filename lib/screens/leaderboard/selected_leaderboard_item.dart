import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SelectedLeaderboardItem extends ConsumerWidget {
  final int rank;
  final String playerUID;
  final DateTime? time;
  final int score;
  // final String totalScore;
  const SelectedLeaderboardItem({
    required this.score,
    required this.rank,
    required this.playerUID,
    // required this.totalScore,
    this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    const type = AccountType.user;
    return Row(
      children: [
        BLText(rank.toString()),
        BLProfilePic(playerUID, type: type),
        BLDisplayName(playerUID, type),
        BLText(
          time == null ? '--' : DateFormat('hh:mm').format(time!),
        ),
      ],
    );
  }
}
