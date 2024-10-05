import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/all_rooms.dart';
import 'package:block_logic/screens/rooms/public_room_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicRooms extends ConsumerStatefulWidget {
  final String? searchQuery;
  const PublicRooms({this.searchQuery, super.key});

  @override
  ConsumerState<PublicRooms> createState() => _PublicRoomsState();
}

class _PublicRoomsState extends ConsumerState<PublicRooms> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final roomsProvider = ref.watch(
      RoomsProvider(
        searchQuery: widget.searchQuery,
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
    );

    return roomsProvider.when(
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
              'There are no public rooms\nat the moment.',
              alignCenter: true,
            ),
          );
        }
        return Stack(
          children: [
            ListView.builder(
                // padding: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: rooms.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: PublicRoomItem(room: rooms[i], toggleProcessing: toggleProcessing),
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
