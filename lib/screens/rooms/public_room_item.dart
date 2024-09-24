import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/rooms/room_password_dialog.dart';
import 'package:block_logic/screens/rooms/room_state.dart';
import 'package:block_logic/screens/rooms/waiting_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRoomItem extends ConsumerStatefulWidget {
  final Room room;
  final VoidCallback toggleProcessing;
  const PublicRoomItem({
    super.key,
    required this.room,
    required this.toggleProcessing,
  });

  @override
  ConsumerState<PublicRoomItem> createState() => _PublicRoomItemState();
}

class _PublicRoomItemState extends ConsumerState<PublicRoomItem> {
  late final CustomNavigation nav;
  late final DialogService dialog;
  late final RoomManager roomManager;
  late final Toast toast;
  @override
  Widget build(BuildContext context) {
    final hostData = ref.watch(SelectedUserProvider(widget.room.hostID!));
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () async {
              if (widget.room.status != null && widget.room.status == RoomStatus.inGame) {
                return;
              }
              widget.toggleProcessing();
              if (widget.room.password == null || widget.room.password!.isEmpty) {
                await roomManager.joinRoom(widget.room.id!);
                if (context.mounted) {
                  nav.push(
                    context,
                    WaitingRoom(widget.room.id!),
                  );
                }
              } else {
                final result = await dialog.show(context, RoomPasswordDialog(pass: widget.room.password!, hostID: widget.room.hostID!));
                await roomManager.joinRoom(widget.room.id!);
                if (result is bool && result) {
                  if (!context.mounted) return;
                  nav.push(context, WaitingRoom(widget.room.id!));
                }
              }
              widget.toggleProcessing();
            },
            hasPass: widget.room.password?.isNotEmpty,
            color: Colors.black,
            //icon: room.icon ?? '',
            title: widget.room.name ?? '',
            subTitle: hostData?.displayName ?? '--',
            bottomRowStart: BLRoomState(widget.room.status),
            bottomRowEnd: BLText(
              '${widget.room.players?.length ?? '--'}/${widget.room.maxPlayers ?? '--'}',
              bold: true,
              color: widget.room.status == RoomStatus.inGame
                  ? Colors.amber
                  : widget.room.maxPlayers == null
                      ? Colors.grey
                      : widget.room.players!.length == widget.room.maxPlayers
                          ? Colors.red
                          : Colors.green,
            ),
          );
        },
        error: genericError,
        loading: genericLoading);
  }

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    roomManager = ref.read(roomManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }
}
