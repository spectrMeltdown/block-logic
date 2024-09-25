import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SelectedLeaderboardItem extends ConsumerStatefulWidget {
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
  ConsumerState<SelectedLeaderboardItem> createState() => _SelectedLeaderboardItemState();
}

class _SelectedLeaderboardItemState extends ConsumerState<SelectedLeaderboardItem> {
  final type = AccountType.user;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [BLText(widget.rank.toString()), BLProfilePic(widget.playerUID, type: type), BLDisplayName(widget.playerUID, type), BLText(widget.time == null ? '--' : DateFormat('hh:mm').format(widget.time!))],
    );
  }
}
