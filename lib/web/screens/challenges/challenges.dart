import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/all_challenges.dart';
import 'package:block_logic/logic/services/challenge_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Challenges extends ConsumerStatefulWidget {
  const Challenges({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChallengesState();
}

class ChallengesState extends ConsumerState<Challenges> {
  final pageScrollController = ScrollController();
  final searchController = SearchController();
  late final Toast toast;
  late final ChallengeManager manager;
  String selectedChallengeID = '';
  String searchQuery = '';
  bool processing = false;
  bool isAllSelected = false;
  bool deleteMode = false;
  Map<String, bool>? selectedChallengeIDs;

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    manager = ref.read(challengeManagerProvider.notifier);
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final challenges = ref.watch(ChallengesProvider(searchQuery: searchQuery));
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
                                challenges.when(
                                    data: (challenges) {
                                      if (challenges.isEmpty) {
                                        return const Center(
                                          child: BLText('No challenges found.'),
                                        );
                                      }
                                      if (selectedChallengeIDs == null) {
                                        setState(() {
                                          selectedChallengeIDs = {for (final challenge in challenges) challenge.id!: false};
                                        });
                                      }
                                      if (searchQuery.isNotEmpty && challenges.isEmpty) {
                                        return const Center(
                                          child: BLText('No results.'),
                                        );
                                      }
                                      return FadeIn(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: BLTable(
                                              // checkboxes: deleteMode,
                                              columns: [
                                                DataColumn(
                                                    label: Visibility(
                                                  visible: deleteMode,
                                                  child: Checkbox(
                                                      value: isAllSelected,
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          if (value) {
                                                            selectedChallengeIDs!.updateAll((key, value) => true);
                                                          } else {
                                                            selectedChallengeIDs!.updateAll((key, value) => false);
                                                          }
                                                          setState(() {
                                                            isAllSelected = value;
                                                          });
                                                        }
                                                      }),
                                                )),
                                                const DataColumn(label: BLText('Name')),
                                                const DataColumn(label: BLText('Short Description')),
                                                const DataColumn(label: BLText('Difficulty')),
                                                // DataColumn(label: BLText('Tags')),
                                              ],
                                              rows: List.generate(challenges.length, (i) {
                                                return DataRow(
                                                  onSelectChanged: (value) {
                                                    if (!deleteMode) {
                                                      context.go('/challenges/edit/${challenges[i].id}');
                                                    }
                                                  },
                                                  cells: [
                                                    DataCell(
                                                      Visibility(
                                                        visible: deleteMode,
                                                        child: Checkbox(
                                                          value: selectedChallengeIDs![challenges[i].id!], // Handle null safety
                                                          onChanged: (value) {
                                                            debugPrint(challenges[i].id);
                                                            debugPrint(selectedChallengeIDs![challenges[i].id!].toString());
                                                            if (value != null) {
                                                              setState(() {
                                                                selectedChallengeIDs![challenges[i].id!] = value; // Update parent state
                                                                debugPrint(selectedChallengeIDs![challenges[i].id!].toString());
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      BLText(
                                                        challenges[i].name ?? '--',
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    DataCell(
                                                      ConstrainedBox(
                                                        constraints: const BoxConstraints(maxWidth: 400),
                                                        child: BLText(
                                                          challenges[i].shortDescription ?? 'Not set',
                                                          softWrap: true,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      BLText(challenges[i].difficulty?.name ?? '--'),
                                                    ),
                                                  ],
                                                );
                                              })),
                                        ),
                                      );
                                    },
                                    error: genericError,
                                    loading: genericLoading),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    deleteMode
                                        ? BLAdminButton(
                                            type: processing ? AdminBtnType.grey : AdminBtnType.teal,
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [BLText('Cancel')],
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                deleteMode = false;
                                              });
                                            })
                                        : BLAdminButton(
                                            type: processing ? AdminBtnType.grey : AdminBtnType.green,
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
                                            onPressed: () {
                                              if (processing) return;
                                              toggleProcessing();

                                              toggleProcessing();
                                            }),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    BLAdminButton(
                                        type: processing ? AdminBtnType.grey : AdminBtnType.red,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            deleteMode
                                                ? const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.white,
                                                  ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            BLText(deleteMode ? 'Delete selected' : 'Delete Mode')
                                          ],
                                        ),
                                        onPressed: () async {
                                          if (processing) return;
                                          toggleProcessing();
                                          if (!deleteMode) {
                                            setState(() {
                                              deleteMode = true;
                                            });
                                          } else {
                                            if (selectedChallengeIDs!.isNotEmpty && selectedChallengeIDs!.values.any((i) => i)) {
                                              for (final id in selectedChallengeIDs!.entries.where((i) => i.value == true).map((e) => e.key).toList()) {
                                                final error = await manager.delete(id);
                                                if (error != null) {
                                                  if (!context.mounted) return;
                                                  toast.showToast(context, error, type: NotifType.error);
                                                  break;
                                                }
                                              }
                                            } else {
                                              toast.showToast(context, 'Select a challenge.', type: NotifType.error);
                                            }
                                          }
                                          toggleProcessing();
                                        }),
                                  ],
                                )
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

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  void updateSelectedIDs(String id, bool add) {
    // setState(() {
    //   // selectedChallengeIDs.add(id);
    //   selectedChallengeIDs[id] = add;
    // });
    if (id.isEmpty) return;
    if (add) {
      setState(() {
        // selectedChallengeIDs.add(id);
        selectedChallengeIDs![id] = add;
      });
    } else {
      setState(() {
        // selectedChallengeIDs.removeWhere((i) => i == id);
        selectedChallengeIDs![id] = add;
      });
    }
    debugPrint(selectedChallengeIDs.toString());
  }
}
