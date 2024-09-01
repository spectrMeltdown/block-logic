import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_leaderboard.dart';
import 'package:block_logic/screens/rooms/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRoomItem extends ConsumerStatefulWidget {
  final Room room;
  final VoidCallback toggleProcessing;
  const UserRoomItem({
    required this.room,
    required this.toggleProcessing,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserRoomItemState();
}

class _UserRoomItemState extends ConsumerState<UserRoomItem> {
  @override
  Widget build(BuildContext context) {
    return BLTranslucentCard(
      onPressed: () {
        // TODO: Implement game config for host
      },
      //icon: widget.room.icon ?? '',
      title: widget.room.name ?? 'Loading ...',
      subTitle: getLeaderboard(widget.room.id!),
      bottomRowStart: BLRoomState(widget.room.status),
      bottomRowEnd: BLText('${widget.room.maxPlayers} players'),
    );
  }

  String getLeaderboard(String roomID) {
    final leaderboard = ref.read(SelectedLeaderboardProvider(roomID));
    leaderboard.when(
        data: (leaderboard) {
          debugPrint('leadboard called');
        },
        error: genericError,
        loading: genericLoading);

    return '';
  }
}
