import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/leaderboard_selected.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/screens/rooms/room_state.dart';
import 'package:block_logic/screens/rooms/user_room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRooms extends ConsumerStatefulWidget {
  final String? searchQuery;
  const UserRooms({required this.searchQuery, super.key});

  @override
  ConsumerState<UserRooms> createState() => _UserRoomsState();
}

class _UserRoomsState extends ConsumerState<UserRooms> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final ownRooms = ref.watch(SelectedRoomsProvider(auth.getUID()));

    String getLeaderboard(String roomID) {
      final leaderboard = ref.read(SelectedLeaderboardProvider(roomID));
      leaderboard.when(
          data: (leaderboard) {
            debugPrint('leadboard called');
          },
          error: genericError,
          loading: genericLoading);

      return '';
    }

    return ownRooms.when(
      data: (rooms) {
        if (rooms.isEmpty) {
          return const Center(
            child: BLText(
              'You have no rooms yet.\nCreate one in "Creator Mode".',
              alignCenter: true,
            ),
          );
        }
        return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: rooms.length,
            itemBuilder: (context, i) {
              return UserRoomItem();
            });
      },
      error: genericError,
      loading: genericLoading,
    );
  }
}
