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
    'Name',
    'Host',
    'Max Players',
    'Challenges',
    'Status',
  ];
  List<String> challengeIDs = [];
  @override
  Widget build(BuildContext context) {
    final nav = ref.read(customNavigationProvider.notifier);
    final room = ref.watch(SelectedRoomProvider(widget.id));
    final challenges = ref.watch(SelectedChallengesProvider(challengeIDs));
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BLSmallTitle('Room Details'),
        room.when(
            data: (room) {
              if (room == null) {
                return const BLText('Sorry, we couldn\'t find that..');
              }
              challengeIDs = room.challengeIDs ?? [];
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(roomProps.length, (i) => BLText('${roomProps[i]} :')),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BLText(room.name ?? '--'),
                        BLDisplayName(room.hostID ?? '', AccountType.user),
                        BLText(room.maxPlayers != null ? room.maxPlayers.toString() : '--'),
                        challenges.when(
                            data: (challenges) {
                              if (challenges.isEmpty) {
                                return const BLText('Challenges were not found..');
                              }
                              return Wrap(
                                children: List.generate(challenges.length, (i) => BLText(challenges[i].name ?? '--')),
                              );
                            },
                            error: genericError,
                            loading: genericLoading),
                        BLText(room.status?.name ?? '--'),
                      ],
                    )
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
