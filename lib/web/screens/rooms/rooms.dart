import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/all_rooms.dart';
import 'package:block_logic/logic/services/admin_room_manager.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:block_logic/web/screens/rooms/view_room_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomsManager extends ConsumerStatefulWidget {
  const RoomsManager({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomsManagerState();
}

class _RoomsManagerState extends ConsumerState<RoomsManager> {
  final pageScrollController = ScrollController();
  String searchQuery = '';
  bool processing = false;
  late final Toast toast;
  late final AdminRoomManager roomManager;
  late final DialogService dialog;
  late List<Room> roomsList;
  final List<String> roomHeaders = ['Name', 'Host', 'Max Players', 'Status', 'Actions'];

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    roomManager = ref.read(adminRoomManagerProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    final rooms = ref.watch(RoomsProvider(searchQuery: searchQuery));
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
                          return const Center(child: BLText('There are no rooms at the moment.'));
                        }
                        roomsList = rooms;
                        return BLTable(
                            columns: List.generate(roomHeaders.length, (i) => DataColumn(label: BLText(roomHeaders[i]))),
                            rows: List.generate(
                                roomsList.length,
                                (i) => DataRow(
                                        onSelectChanged: (value) async {
                                          if (processing) return;
                                          processing = true;
                                          await dialog.show(context, ViewRoomDialog(roomsList[i].id!));
                                          processing = false;
                                        },
                                        cells: [
                                          DataCell(BLText(roomsList[i].name ?? '--')),
                                          DataCell(roomsList[i].hostID != null ? BLDisplayName(roomsList[i].hostID!, AccountType.user) : const BLText('--')),
                                          DataCell(BLText(roomsList[i].maxPlayers != null ? roomsList[i].maxPlayers.toString() : '--')),
                                          DataCell(BLText(roomsList[i].status != null ? getStatus(roomsList[i].status!) : '--')),
                                          DataCell(SpacedRow(
                                            spacing: 10,
                                            children: [
                                              BLAdminButton(
                                                  type: processing == true ? AdminBtnType.grey : AdminBtnType.orange,
                                                  child: BLText(roomsList[i].adminLocked != null ? (roomsList[i].adminLocked == true ? 'Unlock' : 'Lock') : 'Lock'),
                                                  onPressed: () async {
                                                    if (processing) return;
                                                    setState(() {
                                                      processing = true;
                                                    });
                                                    if (roomsList[i].adminLocked != null && roomsList[i].adminLocked == true) {
                                                      final result = await roomManager.setLock(roomsList[i].id ?? '', false);
                                                      if (result != null) {
                                                        toast.showToast(result, type: NotifType.error);
                                                      }
                                                    } else {
                                                      final result = await roomManager.setLock(roomsList[i].id ?? '', true);
                                                      if (result != null) {
                                                        toast.showToast(result, type: NotifType.error);
                                                      }
                                                    }
                                                    setState(() {
                                                      processing = false;
                                                    });
                                                  }),
                                              BLAdminButton(
                                                  disabled: roomsList[i].adminLocked != null
                                                      ? roomsList[i].adminLocked == true
                                                          ? false
                                                          : true
                                                      : true,
                                                  type: processing == true
                                                      ? AdminBtnType.grey
                                                      : roomsList[i].adminLocked != null
                                                          ? roomsList[i].adminLocked == true
                                                              ? AdminBtnType.red
                                                              : AdminBtnType.grey
                                                          : AdminBtnType.grey,
                                                  child: const BLText('Delete'),
                                                  onPressed: () async {
                                                    if (processing) return;
                                                    setState(() {
                                                      processing = true;
                                                    });
                                                    final result = await roomManager.delete(rooms[i].id ?? '');
                                                    if (result != null) {
                                                      toast.showToast(result, type: NotifType.error);
                                                    }
                                                    setState(() {
                                                      processing = false;
                                                    });
                                                  })
                                            ],
                                          )),
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
      case RoomStatus.locked:
        return RoomStatus.locked.name;
    }
  }
}
