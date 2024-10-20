import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/leaderboard_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/game/game_room.dart';
import 'package:block_logic/screens/rooms/in_game_controls_dialog.dart';
import 'package:block_logic/screens/rooms/kick_player_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class WaitingRoom extends ConsumerStatefulWidget {
  final String roomID;
  const WaitingRoom(this.roomID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends ConsumerState<WaitingRoom> {
  bool processing = false;
  late final CustomNavigation nav;
  late final DialogService dialog;
  late final RoomManager roomManager;
  late final Toast toast;
  late final AuthService auth;
  late final LeaderboardManager leaderboardManager;
  bool alreadyPopped = false;
  bool playerLeave = false;
  bool called = false;
  bool hostInRoom = false;
  bool roomFull = false;
  String? roomName;

  void toggleProcessing() {
    if (mounted) {
      setState(() {
        processing = !processing;
      });
    }
  }

  void exit() async {
    if (processing) return;
    toggleProcessing();
    final exit = await dialog.show(context, const ConfirmDialog());
    if (mounted && exit is bool && exit) {
      // player leave to prevent duplicate popping
      setState(() {
        playerLeave = true;
      });
      await roomManager.leaveRoom(widget.roomID);
      await FirebaseDatabase.instance.ref('rooms/${widget.roomID}/players/${auth.getUID()}').onDisconnect().cancel();
      if (!mounted) return;
      nav.pop(context);
    }
    toggleProcessing();
  }

  Future<void> pop(String result) async {
    await FirebaseDatabase.instance.ref('rooms/${widget.roomID}/players/${auth.getUID()}').onDisconnect().cancel();
    if (!alreadyPopped) {
      setState(() {
        alreadyPopped = true;
      });
      if (!playerLeave) {
        if (!mounted) return;
        nav.pop(context, result);
      }
    }
  }

  Future<void> updateRoomState(Room room) async {
    if (processing) return;
    processing = true;
    if (mounted) {
      setState(() {
        hostInRoom = room.players != null && room.players!.keys.toList().contains(room.hostID);
        roomFull = room.players != null && room.players!.length >= room.maxPlayers!;
      });
    }
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(SelectedRoomProvider(widget.roomID));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        exit();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Background(
                  child: SafeArea(
                child: Column(
                  children: [
                    BLSmallTitle(
                      roomName ?? '',
                      size: 18,
                      color: Colors.blue,
                    ),
                    if (roomFull == false) BLText('Waiting for other players ...'),
                    if (roomFull && hostInRoom)
                      BLText(
                        'Waiting for host to start game ...',
                        size: 14,
                      ),
                    if (!hostInRoom) BLText('Waiting for host ...'),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: BLBorderedPanel(
                          child: room.when(
                              data: (room) {
                                // internet problem, room deleted, etc
                                if (room == null) {
                                  return const BLText('Failed getting room details.');
                                }
                                roomName ??= '${room.name}';
                                final uid = FirebaseAuth.instance.currentUser!.uid;
                                Future.delayed(Duration(milliseconds: 500), () {
                                  updateRoomState(room);
                                });
                                // dPrint(hostInRoom.toString());
                                // if any player has false value (left the room by purposely disconnecting), remove that player
                                if (room.players != null && room.players!.entries.any((e) => e.value == false)) {
                                  Future.microtask(() async {
                                    if (called) return;
                                    called = true;
                                    await removePlayersWithFalseValue(widget.roomID);
                                    called = false;
                                  });
                                }
                                // if host has started the game, join the game
                                if (room.status == RoomStatus.inGame) {
                                  WidgetsBinding.instance.addPostFrameCallback((d) {
                                    if (!context.mounted) return;
                                    enterGame(room);
                                  });
                                }
                                // if room not empty, and player is not in it
                                if (room.players != null && room.players!.isNotEmpty && !room.players!.keys.toList().contains(uid)) {
                                  Future.microtask(() {
                                    if (!context.mounted) return;
                                    pop('kicked');
                                  });
                                  return const BLError();
                                }
                                // if room is empty, it was disbanded
                                if (room.players == null || room.players!.isEmpty) {
                                  Future.microtask(() {
                                    if (!context.mounted) return;
                                    pop('disbanded');
                                  });
                                }
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    BLText(
                                      '${room.players?.length} / ${room.maxPlayers}',
                                      color: room.players!.length >= room.maxPlayers! ? Colors.orange : Colors.white,
                                    ),
                                    Flexible(
                                      child: Stack(
                                        children: [
                                          ListView(
                                            padding: EdgeInsets.zero,
                                            children: List.generate(room.players!.length, (i) {
                                              return Padding(
                                                key: ValueKey(room.players!.keys.toList()[i]),
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                child: WidgetAnimator(
                                                    incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
                                                    child: ListTile(
                                                      leading: BLProfilePic(type: AccountType.user, room.players!.keys.toList()[i]),
                                                      title: BLDisplayName(
                                                        room.players!.keys.toList()[i],
                                                        AccountType.user,
                                                        size: 16,
                                                      ),
                                                    )),
                                              );
                                            }),
                                          ),
                                          if (auth.getUID() == room.hostID)
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  BLButton(
                                                      type: processing ? BtnType.grey : BtnType.normal,
                                                      paddingX: 10,
                                                      onPressed: () async {
                                                        final result = await showDialog(
                                                          context: context,
                                                          builder: (context) => InGameControlsDialog(room.id!),
                                                        );
                                                        if (result is String && result == 'kickPlayer') {
                                                          if (!context.mounted) return;
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) => KickPlayerBottomSheet(room.id!),
                                                          );
                                                        }
                                                      },
                                                      child: const Icon(Icons.settings)),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  BLButton(
                                                      type: processing ? BtnType.grey : BtnType.orange,
                                                      onPressed: () {
                                                        start(context, room, true);
                                                      },
                                                      child: const BLText(
                                                        'Start\n& leave',
                                                        alignCenter: true,
                                                        color: Colors.white,
                                                      )),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  BLButton(
                                                      type: processing ? BtnType.grey : BtnType.green,
                                                      onPressed: () {
                                                        start(context, room);
                                                      },
                                                      child: const BLText(
                                                        'Start\n& join',
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                              error: genericError,
                              loading: genericLoading),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    BLButton(
                        type: processing ? BtnType.grey : BtnType.red,
                        paddingX: MediaQuery.of(context).size.width / 3,
                        onPressed: () {
                          exit();
                        },
                        child: const BLText('Leave')),
                    const SizedBox(height: 30),
                  ],
                ),
              )),
              if (processing)
                Container(
                  color: Colors.black.withOpacity(0.6),
                  child: const BLLoading(
                    message: 'Loading...',
                  ),
                )
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    roomManager = ref.read(roomManagerProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    leaderboardManager = ref.read(leaderboardManagerProvider.notifier);
    FirebaseDatabase.instance.ref('rooms/${widget.roomID}/players/${auth.getUID()}').onDisconnect().set(false).then((status) {
      playerLeave = true;
    });
  }

  void start(BuildContext context, Room room, [bool startLeave = false]) async {
    if (processing) return;
    toggleProcessing();
    final leaderboardID = '${room.id}--${DateTime.now().millisecondsSinceEpoch}';

    /// create leaderboard ahead of time
    final result = await leaderboardManager.create(
      Leaderboard(
        id: leaderboardID,
        roomID: room.id,
        roomName: room.name,
        players: room.players!.keys.toList(),
        totalScore: room.challengeIDs!.length,
        status: LeaderboardStatus.pending,
        date: DateTime.now(),
      ),
    );

    /// update room status
    final result2 = await roomManager.update(
      Room(
        id: widget.roomID,
        status: RoomStatus.inGame,
        currentLeaderboardID: leaderboardID,
      ),
    );
    // if id not returned, exit function
    if (result != null || result2 != null) {
      if (!context.mounted) return;
      toast.showToast(context, 'Error starting the game.', type: NotifType.error);
      toggleProcessing();
    }
    // else to game
    else {
      // optionally start the game and leave the game, only if host
      if (startLeave) {
        if (!context.mounted) return;
        nav.pop(context);
      } else {
        if (!context.mounted) return;
        final updatedRoom = room.copyWith(
          id: widget.roomID,
          status: RoomStatus.inGame,
          currentLeaderboardID: leaderboardID,
        );
        nav.pushReplace(context, GameRoom(updatedRoom));
      }
    }
  }

  Future<void> enterGame(Room room) async {
    if (processing) return;
    processing = true;
    nav.pushReplace(context, GameRoom(room));
    processing = false;
  }
}

Future<void> removePlayersWithFalseValue(String roomID) async {
  final result = await FirebaseDatabase.instance.ref('rooms/$roomID/players').runTransaction((obj) {
    var players = (obj as Map<Object?, Object?>?)?.map((k, v) => MapEntry<String, Object?>(k as String, v as bool)).cast<String, Object?>();
    if (players != null && players.entries.any((e) => e.value == false)) {
      List<String> keysToRemove = [];
      // dPrint(players.toString());
      for (final player in players.entries) {
        if (player.value == false) {
          keysToRemove.add(player.key);
        }
      }
      for (final key in keysToRemove) {
        players.removeWhere((k, v) => k == key);
      }
      // dPrint(players.toString());
      return Transaction.success(players);
    }
    return Transaction.abort();
  });
  if (result.committed) {
    // dPrint('Commited');
  } else {
    // dPrint('Aborted');
  }
}
