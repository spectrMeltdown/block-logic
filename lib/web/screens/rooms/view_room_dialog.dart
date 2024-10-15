import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenges.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewRoomDialog extends ConsumerStatefulWidget {
  final String id;
  const ViewRoomDialog(this.id, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectedRoomState();
}

class _SelectedRoomState extends ConsumerState<ViewRoomDialog> {
  bool processing = false;
  final List<String> roomProps = [
    'Name: ',
    'Host: ',
    'Max Players: ',
    'Challenges: ',
    'Status: ',
  ];

  @override
  Widget build(BuildContext context) {
    final nav = ref.read(customNavigationProvider.notifier);
    final room = ref.watch(SelectedRoomProvider(widget.id));
    return BLDialog(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BLSmallTitle('Room Details'),
            room.when(
                data: (room) {
                  if (room == null) {
                    return const BLText('Sorry, we couldn\'t find that..');
                  }
                  final challenges = ref.watch(SelectedChallengesProvider(room.challengeIDs!));
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BLText(roomProps[0]),
                            BLText(room.name ?? '--'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BLText(roomProps[1]),
                            BLDisplayName(room.hostID ?? '', AccountType.user),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BLText(roomProps[2]),
                            BLText(room.maxPlayers != null ? room.maxPlayers.toString() : '--'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BLText(roomProps[3]),
                            challenges.when(
                                data: (challenges) {
                                  if (challenges.isEmpty) {
                                    return const BLText('Challenges were not found..');
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(challenges.length, (i) => BLText('${challenges[i].name ?? '--'}${challenges.length > 1 ? ',' : ''}')),
                                  );
                                },
                                error: (error, stackTrace) => BLText('Error loading..'),
                                loading: () {
                                  return BLText('Loading ..');
                                }),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BLText(roomProps[4]),
                            BLText(room.status?.name ?? '--'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                error: genericError,
                loading: genericLoading),
            BLAdminButton(type: AdminBtnType.red, child: const BLText('Back'), onPressed: () => nav.pop(context))
          ],
        ));
  }
}
