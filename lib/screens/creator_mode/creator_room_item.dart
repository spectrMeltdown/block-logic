import 'package:block_logic/components/card/card_translucent.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorRoomItem extends ConsumerWidget {
  final String hostID;
  final Room room;
  const CreatorRoomItem({super.key, required this.room, required this.hostID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostData = ref.watch(SelectedUserProvider(hostID));
    final nav = ref.read(customNavigationProvider);
    return hostData.when(
        data: (hostData) {
          return BLTranslucentCard(
            onPressed: () {},
            color: Colors.black,
            //icon: room.icon ?? '',
            title: room.name ?? '',
            subTitle:
                '${room.maxPlayers == null ? '--' : 'Max players: ${room.maxPlayers}'}, Challenges: ${room.challengeIDs?.length}',
          );
        },
        error: genericError,
        loading: genericLoading);
  }
}
