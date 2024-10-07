import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/rooms/in_game_controls_dialog.dart';
import 'package:block_logic/screens/rooms/kick_player_bottom_sheet.dart';
import 'package:block_logic/screens/rooms/room_state.dart';
import 'package:block_logic/screens/rooms/waiting_room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRoomItem extends ConsumerStatefulWidget {
  final Room room;
  final VoidCallback toggleProcessing;
  const UserRoomItem({
    super.key,
    required this.room,
    required this.toggleProcessing,
  });

  @override
  ConsumerState<UserRoomItem> createState() => _UserRoomItemState();
}

class _UserRoomItemState extends ConsumerState<UserRoomItem> {
  late final CustomNavigation nav;
  late final DialogService dialog;
  late final RoomManager roomManager;
  late final Toast toast;
  bool called = false;

  Future<void> joinRoom() async {
    final joinSuccess = await roomManager.joinRoom(widget.room.id!);
    if (joinSuccess) {
      if (!mounted) return;
      nav.push(context, WaitingRoom(widget.room.id!));
    } else {
      if (!mounted) return;
      toast.showToast(context, 'Failed to join room.', type: NotifType.error);
    }
    // if (widget.room.players == null || widget.room.players!.isEmpty) {
    //   // final currentPlayers = await roomManager.currentPlayers(widget.room.id!);
    //   // check if room is full. Minus 1 so that the host can join.

    // } else {
    //   if (!mounted) return;
    //   toast.showToast(context, 'Error joining room.', type: NotifType.info);
    // }
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
            onLongPress: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => InGameControlsDialog(widget.room.id!),
              );
              if (result is String && result == 'kickPlayer') {
                if (!context.mounted) return;
                showBottomSheet(
                  context: context,
                  builder: (context) => KickPlayerBottomSheet(widget.room.id!),
                );
              }
            },
            onPressed: () async {
              widget.toggleProcessing();
              if (widget.room.status != RoomStatus.inGame) {
                await joinRoom();
              } else {
                toast.showToast(context, 'Room already started', type: NotifType.error);
              }
              widget.toggleProcessing();
            },
            color: Colors.black,
            //icon: room.icon ?? '',
            title: widget.room.name ?? '',
            bottomRowStart: (widget.room.players?.length ?? widget.room.maxPlayers!) >= widget.room.maxPlayers!
                ? const BLText(
                    'Full (Host can still join)',
                    color: Colors.deepOrange,
                  )
                : BLRoomState(widget.room.status),
            bottomRowEnd: BLText(
              '${widget.room.players?.length ?? '0'}/${widget.room.maxPlayers ?? '--'}',
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

Future<void> resetRoom(String roomID) async {
  String leaderboardID = '';
  final result = await FirebaseDatabase.instance.ref('rooms/$roomID').runTransaction((obj) {
    var room = obj == null ? null : Room.fromRTDB(obj);
    // debugPrint(room?.toJSON().toString());
    if (room != null) {
      leaderboardID = room.currentLeaderboardID ?? '';
      room = room.copyWith(status: RoomStatus.available);
      return Transaction.success(room.toJSON());
    }
    return Transaction.abort();
  });
  if (result.committed && leaderboardID.isNotEmpty) {
    // also set relevant leaderboard to incomplete
    await FirebaseDatabase.instance.ref('leaderboards/$leaderboardID').runTransaction((obj) {
      var lb = obj == null ? null : Leaderboard.fromRTDB(obj);
      // debugPrint(room?.toJSON().toString());
      if (lb != null) {
        lb = lb.copyWith(status: LeaderboardStatus.incomplete);
        return Transaction.success(lb.toJSON());
      }
      return Transaction.abort();
    });
  }
}
