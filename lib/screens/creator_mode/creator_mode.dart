import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/help_dialog.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/bottom_sheet.dart';
import 'package:block_logic/screens/creator_mode/creator_room_item.dart';
import 'package:block_logic/screens/creator_mode/add_new_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreatorMode extends ConsumerWidget {
  const CreatorMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider.notifier);
    final ownRooms = ref.watch(SelectedRoomsProvider(auth.getUID()));
    final addBottomSheet = ref.read(bottomSheetServiceStateProvider);
    debugPrint(IconTheme.of(context).color.toString());
    return Scaffold(
      body: Background(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BLBackButton(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const BLHelpDialog());
                    },
                    icon: const Icon(FontAwesomeIcons.circleQuestion))
              ],
            ),
          ),
          const BLTitle(
            'Creator Mode',
            bottomPadding: 10,
          ),
          const BLText(
            'Select/create a room',
            size: 18,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: BLBorderedPanel(
                child: ownRooms.when(
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
                    shrinkWrap: true,
                    itemCount: rooms.length,
                    itemBuilder: (context, i) {
                      return CreatorRoomItem(
                          room: rooms[i], hostID: rooms[i].hostID ?? '');
                    });
              },
              error: genericError,
              loading: genericLoading,
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: BLButton(
              onPressed: () => addBottomSheet.show(
                  context, const AddRoomBottomSheet(),
                  isScrollControlled: true),
              paddingX: 110,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FontAwesomeIcons.plus, size: 16),
                  SizedBox(
                    width: 10,
                  ),
                  BLText(
                    'Add room',
                    size: 16,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
