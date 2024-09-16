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

class CreatorRoomItem extends ConsumerStatefulWidget {
  final String hostID;
  final Room room;
  const CreatorRoomItem({super.key, required this.room, required this.hostID});

  @override
  ConsumerState<CreatorRoomItem> createState() => _CreatorRoomItemState();
}

class _CreatorRoomItemState extends ConsumerState<CreatorRoomItem> {
  // late final BottomSheetService bottomSheet;
  late final DialogService dialog;
  late final CustomNavigation nav;
  late final Toast toast;

  @override
  Widget build(BuildContext context) {
    final hostData = ref.watch(SelectedUserProvider(widget.hostID));
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () {
              if (widget.room.adminLocked != null && widget.room.adminLocked == true) {
                toast.showToast('Cannot edit room, locked by admin', type: NotifType.error);
              } else {
                nav.push(context, EditRoomBottomSheet(widget.room.id!));
              }
            },
            onLongPress: () {
              dialog.show(context, DeleteRoomDialog(widget.room.id!), barrierDismissable: false);
            },
            color: Colors.black,
            //icon: room.icon ?? '',
            title: widget.room.name ?? '',
            subTitle:
                '${widget.room.maxPlayers == null ? '--' : 'Max players: ${widget.room.maxPlayers}'}, Challenges: ${widget.room.challengeIDs?.length}',
          );
        },
        error: genericError,
        loading: genericLoading);
  }

  @override
  void initState() {
    // bottomSheet = ref.read(bottomSheetServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }
}
