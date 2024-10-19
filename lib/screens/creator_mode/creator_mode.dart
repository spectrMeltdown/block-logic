import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/dialog/help.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/creator_mode/add_new_room.dart';
import 'package:block_logic/screens/creator_mode/creator_room_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class CreatorMode extends ConsumerStatefulWidget {
  const CreatorMode({super.key});

  @override
  ConsumerState<CreatorMode> createState() => _CreatorModeState();
}

class _CreatorModeState extends ConsumerState<CreatorMode> {
  bool processing = false;
  int roomsLength = 0;
  late final Toast toast;
  late final CustomNavigation nav;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider.notifier);
    final ownRooms = ref.watch(SelectedRoomsProvider(auth.getUID()));
    // dPrint(IconTheme.of(context).color.toString());
    return Scaffold(
      body: Background(
          child: SafeArea(
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
                            builder: (context) => const BLHelpDialog(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BLText(
                                        'Creator mode is where you can manage your rooms, meaning you can create, delete, or edit any of your rooms.\n',
                                        softWrap: true,
                                        color: Colors.white,
                                      ),
                                      BLText(
                                        'Usage:',
                                        bold: true,
                                      ),
                                      BLText(
                                        'Long-press: Delete room',
                                        softWrap: true,
                                      ),
                                      BLText(
                                        'Short-press: Edit room',
                                        softWrap: true,
                                      ),
                                      BLText(
                                        '\nAbout room creation:',
                                        softWrap: true,
                                        bold: true,
                                      ),
                                      BLText(
                                        '- Limited to 10 rooms per user.',
                                        softWrap: true,
                                      ),
                                      BLText(
                                        '- You can set a password so only limited players may join.',
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ));
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
              'Customize your rooms',
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
                        'You have no rooms yet.',
                        alignCenter: true,
                      ),
                    );
                  }
                  setState(() {
                    roomsLength = rooms.length;
                  });
                  return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      itemCount: roomsLength,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CreatorRoomItem(room: rooms[i], hostID: rooms[i].hostID ?? ''),
                        );
                      });
                },
                error: genericError,
                loading: genericLoading,
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: BLButton(
                onPressed: () async {
                  if (processing) return;
                  processing = true;
                  if (roomsLength == 10) {
                    if (!context.mounted) return;
                    toast.showToast(context, 'You have reached the maximmum number of rooms.\nPlease delete a room to add another.', withTransparency: false, duration: const Duration(seconds: 6), alignment: Alignment.bottomCenter, margin: const EdgeInsets.only(bottom: 60, left: 20, right: 20), type: NotifType.error);
                  } else {
                    nav.push(context, const AddRoomBottomSheet(), transition: PageTransitionType.rightToLeftJoined, childCurrent: const CreatorMode());
                  }
                  processing = false;
                },
                child: const Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    // addBottomSheet = ref.read(bottomSheetServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }
}
