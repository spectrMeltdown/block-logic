import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/firebase_providers/all_challenges.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenge.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
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
  final List<String> challengeProps = [
    'Name',
    'Short Description',
    'Additional Info',
    'Limitations',
    'Blocks',
    'Difficulty',
    'Tags',
  ];
  late final List<TextEditingController> challengeEditingControllers;
  @override
  Widget build(BuildContext context) {
    final challenges = ref.watch(challengesProvider);
    final selectedChallenge = ref.watch(SelectedChallengeProvider(''));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    padding: const EdgeInsets.all(15),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: width <= desktopMin
                                  ? width * 0.8
                                  : width * 0.4,
                              maxHeight: height * 0.5),
                          child: Column(
                            children: [
                              AdminSearchBar(
                                  searchController: searchController),
                              Expanded(
                                child: BLCardSimple(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        challenges.when(
                                            data: (challenges) {
                                              if (challenges.isEmpty) {
                                                return const Center(
                                                  child: BLText(
                                                      'No challenges found.'),
                                                );
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: BLTable(
                                                  columns: List.generate(
                                                      challengeProps.length,
                                                      (i) {
                                                    return DataColumn(
                                                        label: BLText(
                                                            challengeProps[i]));
                                                  }),
                                                  rows: List.generate(
                                                      challenges.length, (i) {
                                                    return DataRow(
                                                        cells: List.generate(
                                                            challengeProps
                                                                .length, (i) {
                                                      return DataCell(BLText(
                                                          challenges[i].name ??
                                                              '--'));
                                                    }));
                                                  }),
                                                ),
                                              );
                                            },
                                            error: genericError,
                                            loading: genericLoading)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: width <= desktopMin
                                  ? width * 0.8
                                  : width * 0.4,
                              maxHeight: height * 0.5),
                          child: BLCardSimple(
                              child: selectedChallenge.when(
                                  data: (challenge) {
                                    if (challenge == null) {
                                      return const Center(
                                        child: BLText(
                                            'Couldn\'t load that challenge..'),
                                      );
                                    }
                                    return Column(
                                      children: List.generate(
                                          challengeProps.length, (i) {
                                        return Row(children: [
                                          BLText(challengeProps[i]),
                                          BLTextBox(
                                              controller:
                                                  challengeEditingControllers[
                                                      i])
                                        ]);
                                      }),
                                    );
                                  },
                                  error: selectedChallengeID.isEmpty
                                      ? (error, stackTrace) => const Center(
                                            child: BLText('Select a challenge'),
                                          )
                                      : genericError,
                                  loading: genericLoading)),
                        )
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

  @override
  void initState() {
    challengeEditingControllers = List.generate(challengeProps.length, (i) {
      return TextEditingController();
    });
    super.initState();
  }
}
