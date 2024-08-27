import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/screens/game/game_room.dart';
import 'package:flutter/foundation.dart';
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
  @override
  Widget build(BuildContext context) {
    final room = ref.watch(SelectedRoomProvider(widget.roomID));
    final nav = ref.read(customNavigationProvider);
    final dialog = ref.read(dialogServiceStateProvider);
    final roomManger = ref.read(roomManagerProvider.notifier);

    void exit() async {
      final exit = await dialog.show(context, const ConfirmDialog());
      if (context.mounted && exit is bool && exit) {
        nav.pop(context);
        if (roomID != null) await roomManger.leaveRoom(roomID!);
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
                                    if (kDebugMode)
                                      Positioned(
                                        bottom: 0,
                                        left: MediaQuery.of(context).size.width / 4,
                                        child: BLButton(
                                            onPressed: () {
                                              nav.pushReplace(context, GameRoom(room));
                                            },
                                            child: const BLText('Start game')),
                                      ),
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
}
