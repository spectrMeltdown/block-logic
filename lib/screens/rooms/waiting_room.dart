import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaitingRoom extends ConsumerStatefulWidget {
  final String roomID;
  const WaitingRoom(this.roomID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends ConsumerState<WaitingRoom> {
  @override
  Widget build(BuildContext context) {
    final room = ref.watch(SelectedRoomProvider(widget.roomID));
    final nav = ref.read(customNavigationProvider);
    final dialog = ref.read(dialogServiceStateProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        final exit = await dialog.show(context, const ConfirmDialog());
        if (context.mounted && exit is bool && exit) {}
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BLBorderedPanel(
                    child: room.when(
                        data: (room) {
                          if (room == null) {
                            return const BLError();
                          }
                          if (room.players!.isEmpty) {
                            return const BLError(message: 'No players!');
                          }
                          return Column(
                            children: [
                              BLText(
                                  '${room.players?.length} / ${room.maxPlayers}'),
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: room.players!.length,
                                  itemBuilder: (context, i) {
                                    return Row(
                                      children: [
                                        BLProfilePic(room.players![i]),
                                        BLDisplayName(room.players![i])
                                      ],
                                    );
                                  })
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
                    nav.pop(context);
                  },
                  child: const BLText('Exit')),
              const SizedBox(height: 10),
            ],
          ))),
    );
  }
}
