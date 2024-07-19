import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/rooms.dart';
import 'package:block_logic/logic/firebase_providers/user.dart';
import 'package:block_logic/screens/rooms/rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRooms extends ConsumerStatefulWidget {
  const PublicRooms({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublicRoomsState();
}

class _PublicRoomsState extends ConsumerState<PublicRooms> {
  @override
  Widget build(BuildContext context) {
    final ownRooms = ref.watch(roomsProvider);

    return Column(
      children: [
        ownRooms.when(
          data: (rooms) {
            if (rooms.isEmpty) {
              return const Expanded(
                  child: Center(
                child: BLText(
                  'There are no available rooms\nat the moment.',
                  alignCenter: true,
                ),
              ));
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: rooms.length,
                itemBuilder: (context, i) {
                  return RoomItem(
                      room: rooms[i], hostID: rooms[i].hostID ?? '');
                });
          },
          error: (error, stackTrace) => const BlankWidget(),
          loading: () => const BlankWidget(),
        )
      ],
    );
  }
}

class RoomItem extends ConsumerStatefulWidget {
  const RoomItem({super.key, required this.room, required this.hostID});
  final String hostID;
  final Room room;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomItemState();
}

class _RoomItemState extends ConsumerState<RoomItem> {
  late final Room room;

  @override
  void initState() {
    room = widget.room;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hostData = ref.watch(UserAccountProvider(widget.hostID));
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () {
              // TODO: Implement game config for host
            },
            icon: room.icon ?? '',
            title: room.name ?? '',
            subTitle: hostData?.displayName ?? '',
            bottomRowStart:
                BLRoomState((room.password == null) ? 'open' : 'closed'),
            bottomRowEnd: BLText('${room.capacity}'),
          );
        },
        error: genericError,
        loading: genericLoading);
  }
}
