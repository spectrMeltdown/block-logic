import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/components/help_dialog.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomSelector extends StatefulWidget {
  const RoomSelector({super.key});

  @override
  State<RoomSelector> createState() => _RoomSelectorState();
}

class _RoomSelectorState extends State<RoomSelector> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              BLBackButton(),
              IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => BLHelpDialog());
                  },
                  icon: Icon(FontAwesomeIcons.circleQuestion))
            ]),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [BLTitle('ROOMS')]),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: BLTextBox(
                  controller: searchController,
                  labelText: 'Search ...',
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
