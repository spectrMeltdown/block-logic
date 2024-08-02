import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/room_leaderboards.dart';
import 'package:block_logic/logic/firebase_providers/room_selected.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRooms extends ConsumerStatefulWidget {
  const UserRooms({super.key});

  @override
  ConsumerState<UserRooms> createState() => _UserRoomsState();
}

class _UserRoomsState extends ConsumerState<UserRooms> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final ownRooms = ref.watch(OwnRoomsProvider(auth.getUID()));

    return Column(
      children: [
        ownRooms.when(
          data: (rooms) {
            if (rooms.isEmpty) {
              return const Expanded(
                  child: Center(
                child: BLText(
                  'You have no rooms yet.\nCreate one in "Creator Mode".',
                  alignCenter: true,
                ),
              ));
            }
            return Expanded(
              child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, i) {
                    debugPrint(rooms[i].name.toString());
                    final leaderboards =
                        ref.watch(OwnRoomLeaderboardsProvider(rooms[i].id!));
                    leaderboards.when(
                        data: (leaderboard) {
                          debugPrint('leadboard called');
                          return BLTranslucentCard(
                            onPressed: () {
                              // TODO: Implement game config for host
                            },
                            icon: rooms[i].icon ?? '',
                            title: rooms[i].name ?? 'Loading ...',
                            subTitle: leaderboard.length.toString(),
                            bottomRowStart: BLRoomState(
                                (rooms[i].password == null)
                                    ? 'open'
                                    : 'closed'),
                            bottomRowEnd:
                                BLText('${rooms[i].capacity} players'),
                          );
                        },
                        error: genericError,
                        loading: genericLoading);

                    return null;
                  }),
            );
          },
          error: (error, stackTrace) => const BlankWidget(),
          loading: () => const BlankWidget(),
        )
      ],
    );
  }
}
