import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/leaderboard/selected_leaderboard.dart';
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
  late CustomNavigation nav;
  @override
  Widget build(BuildContext context) {
    return BLCard(
        outerPadding: const EdgeInsets.symmetric(horizontal: 5),
        color: Colors.white.withOpacity(0.3),
        onPressed: () {
          nav.push(context, SelectedLeaderboard(widget.leaderboard));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLText(widget.leaderboard.roomName ?? ''),
            BLText(widget.leaderboard.date == null ? '--' : DateFormat('dd/MM/yyyy').format(widget.leaderboard.date!)),
          ],
        ));
  }

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }
}
