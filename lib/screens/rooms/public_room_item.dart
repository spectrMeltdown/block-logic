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
import 'package:block_logic/screens/rooms/user_room_item.dart';
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
  int errorTap = 0;
  bool called = false;
  List<String> bannedFromRooms = [];

  Future<void> joinRoom() async {
    final currentPlayers = await roomManager.currentPlayers(widget.room.id!);
    if (currentPlayers != null) {
      // check if room is full. Minus 1 so that the host can join.

      if (currentPlayers.length < widget.room.maxPlayers!) {
        final joinSuccess = await roomManager.joinRoom(widget.room.id!);
        if (joinSuccess) {
          if (!mounted) return;
          final result = await nav.push(context, WaitingRoom(widget.room.id!));
          if (result is String && result == 'kicked') {
            if (!mounted) return;
            toast.showToast(context, 'You have been kicked.', type: NotifType.error);
          } else if (result is String && result == 'disbanded') {
            if (!mounted) return;
            toast.showToast(context, 'Room disbanded', type: NotifType.info);
          }
          return;
        } else {
          if (!mounted) return;
          toast.showToast(context, 'Failed to join room.', type: NotifType.error);
        }
        // if (currentPlayers.contains(widget.room.hostID) || (currentPlayers.length != widget.room.maxPlayers!)) {
        // } else {
        //   if (!mounted) return;
        //   toast.showToast(context, 'Room full.', type: NotifType.info);
        // }
      } else {
        if (!mounted) return;
        toast.showToast(context, 'Room full.', type: NotifType.info);
      }
    } else {
      if (!mounted) return;
      toast.showToast(context, 'Error joining room.', type: NotifType.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hostData = ref.watch(SelectedUserProvider(widget.room.hostID!));
    return hostData.when(
        data: (hostData) {
          // remove any players that are no longer in the room
          if (widget.room.players != null && widget.room.players!.entries.any((e) => e.value == false)) {
            Future.microtask(() async {
              if (called) return;
              called = true;
              await removePlayersWithFalseValue(widget.room.id!);
              called = false;
            });
          }
          // if no players & ingame, reset room (poissibly because all playsers left)
          if ((widget.room.players == null || widget.room.players!.isEmpty) && widget.room.status == RoomStatus.inGame) {
            Future.microtask(() async {
              if (called) return;
              called = true;
              await resetRoom(widget.room.id!);
              called = false;
            });
          }
          return BLTranslucentCard(
            onPressed: () async {
              if (widget.room.status != null && widget.room.status == RoomStatus.inGame) {
                if (errorTap == 2) {
                  toast.showToast(context, 'This room has already started.', type: NotifType.info);
                  setState(() {
                    errorTap = 0;
                  });
                } else {
                  setState(() {
                    errorTap++;
                  });
                }
                return;
              }
              widget.toggleProcessing();
              if (widget.room.password == null || widget.room.password!.isEmpty) {
                await joinRoom();
              } else {
                final result = await dialog.show(
                  context,
                  RoomPasswordDialog(
                    pass: widget.room.password!,
                    hostID: widget.room.hostID!,
                  ),
                );
                if (result is bool && result) {
                  await joinRoom();
                }
              }
              widget.toggleProcessing();
            },
            hasPass: widget.room.password?.isNotEmpty,
            color: Colors.black,
            //icon: room.icon ?? '',
            title: widget.room.name ?? '',
            subTitle: hostData?.displayName ?? '--',
            bottomRowStart: (widget.room.players?.length ?? widget.room.maxPlayers!) >= widget.room.maxPlayers!
                ? const BLText(
                    'Full',
                    color: Colors.red,
                  )
                : BLRoomState(widget.room.status),
            bottomRowEnd: BLText(
              '${widget.room.players?.length ?? '--'}/${widget.room.maxPlayers ?? '--'}',
              bold: true,
              color: widget.room.status == RoomStatus.inGame
                  ? Colors.amber
                  : widget.room.maxPlayers == null
                      ? Colors.grey
                      : (widget.room.players?.length ?? widget.room.maxPlayers!) >= widget.room.maxPlayers!
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
