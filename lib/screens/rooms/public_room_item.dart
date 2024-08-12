import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/rooms/room_password_dialog.dart';
import 'package:block_logic/screens/rooms/room_state.dart';
import 'package:block_logic/screens/rooms/waiting_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRoomItem extends ConsumerWidget {
  final Room room;
  const PublicRoomItem({super.key, required this.room});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostData = ref.watch(SelectedUserProvider(room.hostID!));
    final nav = ref.read(customNavigationProvider);
    final dialog = ref.read(dialogServiceStateProvider);
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () async {
              if (room.password == null || room.password!.isEmpty) {
                nav.push(context, WaitingRoom(room.id!));
              } else {
                final result = await dialog.show(
                    context,
                    RoomPasswordDialog(
                        pass: room.password ?? '', hostID: room.hostID!));
                if (result is bool && result) {
                  if (!context.mounted) return;
                  nav.push(context, WaitingRoom(room.id!));
                }
              }
            },
            hasPass: room.password?.isNotEmpty,
            color: Colors.black,
            icon: room.icon ?? '',
            title: room.name ?? '',
            subTitle: hostData?.displayName ?? '',
            bottomRowStart: BLRoomState(room.status),
            bottomRowEnd: BLText(
              '${room.players?.length ?? '--'}/${room.maxPlayers ?? '--'}',
              bold: true,
              color: room.maxPlayers == null
                  ? Colors.grey
                  : room.players!.length == room.maxPlayers
                      ? Colors.red
                      : Colors.green,
            ),
          );
        },
        error: genericError,
        loading: genericLoading);
  }
}
