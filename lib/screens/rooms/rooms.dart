import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/dialog/help.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/textbox.dart';
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

class _RoomSelectorState extends ConsumerState<RoomSelector> with TickerProviderStateMixin {
  late final TabController tabController;
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    // populateChallenges();
    tabController = TabController(length: 2, vsync: this);
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Background(
            child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const BLBackButton(),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const BLHelpDialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BLText(
                                        'Can\'t find your room?',
                                        bold: true,
                                      ),
                                      BLText(
                                        '- It is possible that your room has been locked by the admin.\n\nPlease message the admin through feedback in the main menu screen if you think this is a mistake.',
                                        softWrap: true,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ));
                      },
                      icon: const Icon(FontAwesomeIcons.circleQuestion))
                ]),
              ),
              const BLTitle('Rooms'),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: BLTextBox(
                        controller: searchController,
                        maxLength: 50,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        labelText: 'Search ...',
                        // suffixIcon: const Icon(
                        //   FontAwesomeIcons.arrowRightLong,
                        //   color: Colors.white,
                        //   size: 20,
                        // ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: BLBorderedPanel(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TabBar(indicatorColor: BLUI().getAppColor(''), labelColor: BLUI().getAppColor(''), dividerColor: BLUI().getAppColor(''), controller: tabController, tabs: const [Tab(text: 'Public rooms'), Tab(text: 'Your rooms')]),
                              SizedBox(
                                width: double.maxFinite,
                                height: mediaQuery.size.height / 1.6,
                                child: TabBarView(
                                  clipBehavior: Clip.antiAlias,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: tabController,
                                  children: [
                                    PublicRooms(searchQuery: searchQuery),
                                    UserRooms(searchQuery: searchQuery),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
