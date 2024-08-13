import 'package:block_logic/components/card/card_translucent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRoomItem extends ConsumerStatefulWidget {
  final Room room;
  final VoidCallback toggleProcessing;
  const UserRoomItem(
      {required this.room, required this.toggleProcessing, super.key});

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
      icon: room.icon ?? '',
      title: room.name ?? 'Loading ...',
      subTitle: getLeaderboard(rooms[i].id!),
      bottomRowStart: BLRoomState(rooms[i].status),
      bottomRowEnd: BLText('${rooms[i].maxPlayers} players'),
    );
  }
}
