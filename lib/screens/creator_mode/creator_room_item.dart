import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/creator_mode/delete_room_dialog.dart';
import 'package:block_logic/screens/creator_mode/edit_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorRoomItem extends ConsumerWidget {
  final String hostID;
  final Room room;
  const CreatorRoomItem({super.key, required this.room, required this.hostID});

  @override
  Widget build(BuildContext context, ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    final dialog = ref.read(dialogServiceProvider.notifier);
    final toast = ref.read(toastProvider.notifier);
    final hostData = ref.watch(SelectedUserProvider(hostID));
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () {
              if (room.adminLocked != null && room.adminLocked == true) {
                if (!context.mounted) return;
                toast.showToast(context, 'Cannot edit room, locked by admin', type: NotifType.error);
              } else {
                nav.push(context, EditRoomBottomSheet(room.id!));
              }
            },
            onLongPress: () {
              dialog.show(context, DeleteRoomDialog(room.id!), barrierDismissable: false);
            },
            color: Colors.black,
            //icon: room.icon ?? '',
            title: room.name ?? '',
            subTitle: '${room.maxPlayers == null ? '--' : 'Max players: ${room.maxPlayers}'}, Challenges: ${room.challengeIDs?.length}',
          );
        },
        error: genericError,
        loading: genericLoading);
  }
}
