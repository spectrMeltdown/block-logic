import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/dialog/help_dialog.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/rooms/public_rooms.dart';
import 'package:block_logic/screens/rooms/user_rooms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomSelector extends ConsumerStatefulWidget {
  const RoomSelector({super.key});

  @override
  ConsumerState<RoomSelector> createState() => _RoomSelectorState();
}

class _RoomSelectorState extends ConsumerState<RoomSelector>
    with TickerProviderStateMixin {
  late final TabController tabController;
  final searchController = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = ref.read(bLMediaQueryProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
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
                ]),
          ),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            BLTitle(
              'ROOMS',
            )
          ]),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: BLTextBox(
                  controller: searchController,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  labelText: 'Search ...',
                  suffixIcon: const Icon(
                    FontAwesomeIcons.arrowRightLong,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              BLBorderedPanel(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                        indicatorColor: BLUI().getAppColor(''),
                        labelColor: BLUI().getAppColor(''),
                        dividerColor: BLUI().getAppColor(''),
                        controller: tabController,
                        tabs: const [
                          Tab(text: 'Available rooms'),
                          Tab(text: 'Your rooms')
                        ]),
                    SizedBox(
                      width: double.maxFinite,
                      height: mediaQuery.screenH(context) / 1.6,
                      child: TabBarView(
                          clipBehavior: Clip.antiAlias,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: const [PublicRooms(), UserRooms()]),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}

class BLRoomState extends StatelessWidget {
  const BLRoomState(this.roomState, {super.key});
  final String roomState;

  @override
  Widget build(BuildContext context) {
    switch (roomState.toLowerCase()) {
      case 'open':
        return BLText(
          '• Open for all',
          color: BLUI().getAppColor('lightgreen'),
        );
      case 'password':
        return BLText(
          '• Password-protected',
          color: BLUI().getAppColor('amber'),
        );
    }
    //debugPrint('undefined room');
    return const BLText('');
  }
}
