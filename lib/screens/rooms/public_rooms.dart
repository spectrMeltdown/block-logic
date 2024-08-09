import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/firebase_providers/all_rooms.dart';
import 'package:block_logic/screens/rooms/room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRooms extends ConsumerWidget {
  const PublicRooms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsProvider);

    return rooms.when(
      data: (rooms) {
        if (rooms.isEmpty) {
          return const Center(
            child: BLText(
              'There are no available rooms\nat the moment.',
              alignCenter: true,
            ),
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: rooms.length,
            itemBuilder: (context, i) {
              return RoomItem(room: rooms[i], hostID: rooms[i].hostID ?? '');
            });
      },
      error: (error, stackTrace) => const BlankWidget(),
      loading: () => const BlankWidget(),
    );
  }
}
