import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/game/game_room.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomItem extends ConsumerWidget {
  final String hostID;
  final Room room;
  const RoomItem({super.key, required this.room, required this.hostID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostData = ref.watch(SelectedUserProvider(hostID));
    final nav = ref.read(customNavigationProvider);
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () => nav.push(context, GameRoom(roomID: room.id ?? '')),
            color: Colors.black,
            icon: room.icon ?? '',
            title: room.name ?? '',
            subTitle: hostData?.displayName ?? '',
            bottomRowStart:
                BLRoomState((room.password == null) ? 'open' : 'closed'),
            bottomRowEnd: BLText(
              '${room.playerCount}/${room.maxPlayers}',
              bold: true,
              color: room.playerCount == room.maxPlayers
                  ? Colors.red
                  : Colors.green,
            ),
          );
        },
        error: genericError,
        loading: genericLoading);
  }
}
