import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/all_rooms.dart';
import 'package:block_logic/screens/rooms/public_room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRooms extends ConsumerWidget {
  final String? searchQuery;
  const PublicRooms({this.searchQuery, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsProvider = ref.watch(RoomsProvider(searchQuery));

    return roomsProvider.when(
      data: (rooms) {
        if (rooms.isEmpty) {
          if (searchQuery != null || searchQuery!.isNotEmpty) {
            return const Center(
              child: BLText(
                'Sorry, we couldn\'t find that..',
                alignCenter: true,
              ),
            );
          }
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
              return PublicRoomItem(room: rooms[i]);
            });
      },
      error: genericError,
      loading: genericLoading,
    );
  }
}
