import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:block_logic/web/screens/challenges/challenges_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Challenges extends ConsumerStatefulWidget {
  const Challenges({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChallengesState();
}

class ChallengesState extends ConsumerState<Challenges> {
  final pageScrollController = ScrollController();
  final searchController = SearchController();
  String selectedChallengeID = '';
  String searchQuery = '';
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: pageScrollController,
            child: SingleChildScrollView(
              controller: pageScrollController,
              child: Column(
                children: [
                  const Header(title: 'Challenges'),
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                            child: Column(
                              children: [
                                const ChallengesSelector(),
                                const SizedBox(height: 10),
                                BLAdminButton(
                                    type: AdminBtnType.teal,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        BLText('Create')
                                      ],
                                    ),
                                    onPressed: () {}),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
