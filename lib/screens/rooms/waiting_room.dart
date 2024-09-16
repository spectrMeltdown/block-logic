import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/profile_pic.dart';
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
      nav.pop(context);
      await roomManager.leaveRoom(widget.roomID);
    }
    toggleProcessing();
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
          body: Background(
              child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: BLSmallTitle('Waiting for other players ...'), // TODO: have the title flash
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BLBorderedPanel(
                      child: room.when(
                          data: (room) {
                            if (room == null) {
                              debugPrint('Room doesn\'t exist');
                              return const BLError();
                            }
                            if (room.players!.isEmpty) {
                              return const Center(child: BLText('No players yet ...'));
                            }
                            if (room.status == RoomStatus.inGame) {
                              Future.microtask(() async {
                                if (!context.mounted) return;
                                nav.pushReplace(context, GameRoom(room));
                              });
                            }
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                BLText(
                                  '${room.players?.length} / ${room.maxPlayers}',
                                  color: room.players!.length == room.maxPlayers! ? Colors.orange : Colors.white,
                                ),
                                Flexible(
                                  child: Stack(
                                    children: [
                                      ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: room.players!.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                              child: WidgetAnimator(
                                                incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
                                                child: Row(
                                                  children: [
                                                    BLProfilePic(type: AccountType.user, room.players![i]),
                                                    const SizedBox(width: 10),
                                                    BLDisplayName(
                                                      room.players![i],
                                                      AccountType.user,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: auth.getUID() == room.hostID,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 5, bottom: 8),
                                                child: BLButton(
                                                    type: processing ? BtnType.grey : BtnType.normal,
                                                    onPressed: () {
                                                      start(context, room, true);
                                                    },
                                                    child: const BLText(
                                                      'Start & leave',
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: auth.getUID() == room.hostID,
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: BLButton(
                                                    type: processing ? BtnType.grey : BtnType.green,
                                                    onPressed: () {
                                                      start(context, room);
                                                    },
                                                    child: const BLText(
                                                      'Start & join',
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
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
          ))),
    );
  }

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider);
    dialog = ref.read(dialogServiceProvider.notifier);
    roomManager = ref.read(roomManagerProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    leaderboardManager = ref.read(leaderboardManagerProvider.notifier);
    super.initState();
  }

  void start(BuildContext context, Room room, [bool startLeave = false]) async {
    if (processing) return;
    toggleProcessing();
    final leaderboardID = '${room.id}${DateTime.now()}';

    /// create leaderboard ahead of time
    final result = await leaderboardManager.create(
      Leaderboard(
        id: leaderboardID,
        roomID: room.id,
        roomName: room.name,
        players: room.players,
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
      toast.showToast('Error starting the game.', type: NotifType.error);
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
}
