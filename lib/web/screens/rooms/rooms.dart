import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/all_rooms.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoomsManager extends ConsumerStatefulWidget {
  const RoomsManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomsManagerState();
}

class _RoomsManagerState extends ConsumerState<RoomsManager> {
  final pageScrollController = ScrollController();
  String searchQuery = '';
  bool processing = false;
  late List<Room> roomsList;
  final List<String> roomHeaders = [
    'Name',
    'Host',
    'Max Players',
    'Status',
  ];

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    final rooms = ref.watch(RoomsProvider(searchQuery));
    return ListView(
      controller: pageScrollController,
      padding: EdgeInsets.zero,
      children: [
        const Header(title: 'Rooms'),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              AdminSearchBar((newQuery) {
                setState(() {
                  searchQuery = newQuery;
                });
              }),
              BLCardSimple(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: rooms.when(
                      data: (rooms) {
                        if (rooms.isEmpty) {
                          return const Center(
                              child:
                                  BLText('There are no rooms at the moment.'));
                        }
                        roomsList = rooms;
                        return BLTable(
                            columns: List.generate(
                                roomHeaders.length,
                                (i) =>
                                    DataColumn(label: BLText(roomHeaders[i]))),
                            rows: List.generate(
                                roomsList.length,
                                (i) => DataRow(
                                        onSelectChanged: (value) {
                                          context
                                              .go('/rooms/${roomsList[i].id}');
                                        },
                                        cells: [
                                          DataCell(BLText(
                                              roomsList[i].name ?? '--')),
                                          DataCell(roomsList[i].hostID != null
                                              ? BLDisplayName(
                                                  roomsList[i].hostID!)
                                              : const BLText('--')),
                                          DataCell(BLText(
                                              roomsList[i].maxPlayers != null
                                                  ? roomsList[i]
                                                      .maxPlayers
                                                      .toString()
                                                  : '--')),
                                          DataCell(BLText(roomsList[i].status !=
                                                  null
                                              ? getStatus(roomsList[i].status!)
                                              : '--')),
                                        ])));
                      },
                      error: genericError,
                      loading: genericLoading),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  String getStatus(RoomStatus roomStatus) {
    switch (roomStatus) {
      case RoomStatus.available:
        return RoomStatus.available.name;
      case RoomStatus.inGame:
        return RoomStatus.inGame.name;
      case RoomStatus.finalizing:
        return RoomStatus.finalizing.name;
    }
  }
}
