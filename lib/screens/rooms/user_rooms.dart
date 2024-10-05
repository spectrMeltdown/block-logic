import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/auth.dart';
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
  late final AuthService auth;
  bool processing = false;

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ownRooms = ref.watch(SelectedRoomsProvider(auth.getUID(), searchQuery: widget.searchQuery));

    return ownRooms.when(
      data: (rooms) {
        if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty && rooms.isEmpty) {
          return const Center(
            child: BLText(
              'Sorry, we couldn\'t find that..',
              alignCenter: true,
            ),
          );
        }
        if (rooms.isEmpty) {
          return const Center(
            child: BLText(
              'You have no rooms yet.\nCreate one in "Creator Mode".',
              alignCenter: true,
            ),
          );
        }
        return Stack(
          children: [
            ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: rooms.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: UserRoomItem(
                      room: rooms[i],
                      toggleProcessing: toggleProcessing,
                    ),
                  );
                }),
            Visibility(
                visible: processing,
                child: Positioned.fill(
                    child: Container(
                        color: Colors.black.withOpacity(0.7),
                        child: const BLLoading(
                          message: 'Joining room...',
                        ))))
          ],
        );
      },
      error: genericError,
      loading: genericLoading,
    );
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }
}
