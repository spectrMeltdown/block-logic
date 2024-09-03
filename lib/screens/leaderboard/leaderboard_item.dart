import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaderboardItem extends ConsumerStatefulWidget {
  final Leaderboard leaderboard;
  const LeaderboardItem(this.leaderboard, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderboardItemState();
}

class _LeaderboardItemState extends ConsumerState<LeaderboardItem> {
  @override
  Widget build(BuildContext context) {
    return BLCard(
        color: Colors.white,
        onPressed: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLText(widget.leaderboard.roomName ?? ''),
            BLText(widget.leaderboard.date == null ? '--' : DateFormat('dd/MM/yyyy').format(widget.leaderboard.date!)),
          ],
        ));
  }
}
