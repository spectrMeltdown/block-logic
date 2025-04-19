import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/leaderboard/selected_leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaderboardItem extends ConsumerStatefulWidget {
  final Leaderboard leaderboard;
  final bool deleteMode;
  final VoidCallback updateDeleteMode;
  final void Function(String, String, bool) updateList;
  const LeaderboardItem(
    this.leaderboard, {
    required this.deleteMode,
    required this.updateDeleteMode,
    required this.updateList,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderboardItemState();
}

class _LeaderboardItemState extends ConsumerState<LeaderboardItem> with AutomaticKeepAliveClientMixin {
  late final CustomNavigation nav;
  late final AuthService auth;
  bool selected = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!widget.deleteMode) {
      setState(() {
        selected = false;
      });
    }
    return BLCard(
        outerPadding: const EdgeInsets.symmetric(horizontal: 5),
        borderColor: widget.deleteMode
            ? selected
                ? Colors.deepOrange
                : Colors.white
            : Colors.white,
        color: Colors.white.withValues(alpha: 0.3),
        onLongPress: () {
          if (widget.deleteMode == false) {
            setState(() {
              selected = !selected;
            });
            widget.updateList(widget.leaderboard.id!, auth.getUID(), true);
            widget.updateDeleteMode();
          }
        },
        onPressed: () {
          if (widget.deleteMode) {
            if (selected) {
              widget.updateList(widget.leaderboard.id!, auth.getUID(), false);
            } else {
              widget.updateList(widget.leaderboard.id!, auth.getUID(), true);
            }
            setState(() {
              selected = !selected;
            });
          } else {
            nav.push(context, SelectedLeaderboard(widget.leaderboard));
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLText(
              widget.leaderboard.roomName ?? '',
              size: 19,
              bold: true,
            ),
            BLText(
              widget.leaderboard.date == null ? '--' : DateFormat('dd/MM/yyyy @ hh:mm a').format(widget.leaderboard.date!),
            ),
          ],
        ));
  }

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }
}
