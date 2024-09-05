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
  String? roomID;
  late final CustomNavigation nav;
  late final DialogService dialog;
  late final RoomManager roomManager;
  late final Toast toast;
  late final AuthService auth;
  late final LeaderboardManager leaderboardManager;
  @override
  Widget build(BuildContext context) {
    final room = ref.watch(SelectedRoomProvider(widget.roomID));

    void exit() async {
      final exit = await dialog.show(context, const ConfirmDialog());
      if (context.mounted && exit is bool && exit) {
        nav.pop(context);
        if (roomID != null) await roomManager.leaveRoom(roomID!);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        exit();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Background(
              child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: BLSmallTitle('Waiting for other players ...'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BLBorderedPanel(
                    child: room.when(
                        data: (room) {
                          if (room == null) {
                            debugPrint('room doesnt exist');
                            return const BLError();
                          }
                          if (room.players!.isEmpty) {
                            return const Center(child: BLText('No players yet ...'));
                          }
                          roomID = room.id;
                          return Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              BLText(
                                '${room.players?.length} / ${room.maxPlayers}',
                                color: Colors.orange,
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
                                    Visibility(
                                      visible: auth.getUID() == room.hostID,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: BLButton(
                                              type: BtnType.green,
                                              onPressed: () async {
                                                /// update room status
                                                await roomManager.update(
                                                  Room(id: roomID, status: RoomStatus.inGame),
                                                );

                                                /// create leaderboard ahead of time
                                                final id = await leaderboardManager.create(
                                                    Leaderboard(
                                                      id: '${room.id}${DateTime.now()}',
                                                      roomID: room.id,
                                                      roomName: room.name,
                                                      totalScore: room.challengeIDs!.length,
                                                      status: LeaderboardStatus.pending,
                                                      date: DateTime.now(),
                                                    ),
                                                    true);
                                                // if id not returned, exit function
                                                if (id == null || id == 'error') {
                                                  toast.showToast('Error initiating game. Check connection..',
                                                      type: NotifType.error);
                                                }
                                                // else to game
                                                else {
                                                  if (!context.mounted) return;
                                                  nav.pushReplace(context, GameRoom(room, id));
                                                }
                                              },
                                              child: const BLText(
                                                'Start game',
                                                color: Colors.white,
                                              )),
                                        ),
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
              const SizedBox(height: 10),
              BLButton(
                  type: BtnType.red,
                  paddingX: MediaQuery.of(context).size.width / 3,
                  onPressed: () {
                    exit();
                  },
                  child: const BLText('Leave')),
              const SizedBox(height: 10),
            ],
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
}
