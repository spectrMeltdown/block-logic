import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KickPlayerBottomSheet extends ConsumerStatefulWidget {
  final String roomID;
  final bool notWaitingRoom;
  const KickPlayerBottomSheet(this.roomID, {this.notWaitingRoom = false, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KickPlayerState();
}

class _KickPlayerState extends ConsumerState<KickPlayerBottomSheet> with TickerProviderStateMixin {
  late final RoomManager roomM;
  late final CustomNavigation nav;
  late final Toast toast;
  // late final BottomSheetService bottomSheet;
  final List<String> selectedIDs = [];
  Widget msg = const BlankWidget();
  bool processing = false;
  void update(String id, bool add) {
    if (add) {
      setState(() {
        selectedIDs.add(id);
      });
    } else {
      setState(() {
        selectedIDs.removeWhere((i) => i == id);
      });
    }
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  @override
  void initState() {
    roomM = ref.read(roomManagerProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(SelectedRoomProvider(widget.roomID, futureOnly: true));
    return BottomSheet(
        animationController: BottomSheet.createAnimationController(this),
        onClosing: () {},
        builder: (context) {
          return room.when(
              data: (data) {
                if (data == null || data.players == null) {
                  return const BLText(
                    'Couldn\'t load the players...',
                    color: Colors.red,
                  );
                }
                if (data.players!.isEmpty) {
                  return const BLText(
                    'No players found.',
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [BLSmallTitle('Select players:'), CloseButton()],
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: data.players!.length,
                        itemBuilder: (context, i) {
                          if (data.players!.keys.toList()[i] == data.hostID) {
                            return const BlankWidget();
                          }
                          return KickPlayerItem(data.players!.keys.toList()[i], update);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (data.players != null && data.players!.length == 1 && data.players!.keys.toList().contains(data.hostID))
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: BLText('No players to kick.'),
                        ),
                      if (data.players != null && data.players!.length > 1 && data.players!.keys.toList().contains(data.hostID))
                        BLButton(
                            onPressed: () async {
                              if (processing) return;
                              toggleProcessing();
                              final String? result = await roomM.removePlayers(widget.roomID, selectedIDs);
                              if (result == null) {
                                if (!context.mounted) return;
                                if (!widget.notWaitingRoom) {
                                  nav.pop(context);
                                }
                                if (!context.mounted) return;
                                toast.showToast(context, 'Kick successful', type: NotifType.success);
                              } else {
                                setState(() {
                                  msg = BLText(
                                    result,
                                    color: Colors.red,
                                  );
                                });
                              }
                              toggleProcessing();
                            },
                            child: const BLText('Kick'))
                    ],
                  ),
                );
              },
              error: genericError,
              loading: genericLoading);
        });
  }
}

class KickPlayerItem extends ConsumerStatefulWidget {
  final String id;
  final void Function(String, bool) update;
  const KickPlayerItem(this.id, this.update, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KickPlayerItemState();
}

class _KickPlayerItemState extends ConsumerState<KickPlayerItem> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: selected,
      onChanged: (value) {
        if (value != null) {
          if (value) {
            setState(() {
              selected = true;
            });
            widget.update(widget.id, true);
          } else {
            setState(() {
              selected = true;
            });
            widget.update(widget.id, false);
          }
        }
      },
      title: BLDisplayName(widget.id, AccountType.user),
    );
  }
}
