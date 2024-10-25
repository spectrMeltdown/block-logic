import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/score.dart';
import 'package:block_logic/logic/firebase_providers/all_scores.dart';
import 'package:block_logic/logic/firebase_providers/selected_users.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/feedback/random_dialog.dart';
import 'package:block_logic/screens/leaderboard/top_three_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedLeaderboard extends ConsumerStatefulWidget {
  final Leaderboard leaderboard;
  final bool showBackButton;
  // final String roomPhotoURL;
  // final String roomTitle;
  const SelectedLeaderboard(
    this.leaderboard, {
    this.showBackButton = true,
    // required this.roomPhotoURL,
    // required this.roomTitle,
    super.key,
  });

  @override
  ConsumerState<SelectedLeaderboard> createState() => _LeaderboardState();
}

// Memoize the topThree list using a StateProvider
final finalTopThreeProvider = StateProvider.family<List<String>, List<Score>>((ref, scores) {
  List<String> topThree = [];
  final count = scores.length > 4 ? 4 : scores.length;
  for (int i = 0; i < count; i++) {
    topThree.add(scores[i].accountID ?? '');
  }
  return topThree;
});

class _LeaderboardState extends ConsumerState<SelectedLeaderboard> {
  final double horizontalPadding = 10;
  late final BLUI blui;
  late final CustomNavigation nav;
  late final SharedPreferences sharedPref;
  bool processing = false;

  String formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    blui = ref.read(bLUIProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    sharedPref = ref.read(sharedPrefProvider);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final scores = ref.watch(AllScoresProvider(widget.leaderboard.id!));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.invalidate(gameManagerProvider);

        nav.pop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
            child: SafeArea(
          child: Column(
            children: [
              if (widget.showBackButton) Align(alignment: Alignment.centerLeft, child: BLBackButton()),
              if (!widget.showBackButton) const SizedBox(height: 20),
              const BLTitle('Leaderboard'),
              BLBorderedPanel(
                child: Column(
                  children: [
                    Container(
                      color: blui.getAppColor('darkblue'),
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  // BLCircular(
                                  //   url: widget.roomPhotoURL,
                                  //   iconSize: 25,
                                  // ),
                                  // const SizedBox(width: 8),
                                  Flexible(
                                    child: BLText(
                                      widget.leaderboard.roomName!,
                                      size: 16,
                                      overflow: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                BLText(
                                  widget.leaderboard.date == null ? '--' : DateFormat('MMMM d, yyyy').format(widget.leaderboard.date!),
                                  color: Colors.amber,
                                  size: 12,
                                ),
                                BLText(
                                  widget.leaderboard.date == null ? '--' : DateFormat('h:mm a').format(widget.leaderboard.date!),
                                  color: Colors.amber,
                                  size: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 50),
                          child: Column(
                            children: [
                              const BLSmallTitle(
                                'Top players',
                                color: Colors.amber,
                              ),
                              Center(
                                child: scores.when(
                                    data: (scores) {
                                      if (scores == null || scores.values.isEmpty) {
                                        return const BLText('Players not found.');
                                      }
                                      if (scores[ScoreStatus.complete] == null || scores[ScoreStatus.complete]!.isEmpty) {
                                        return const BLText('Sorry, no top players.');
                                      }

                                      final finalTop = ref.watch(finalTopThreeProvider(scores[ScoreStatus.complete]!));

                                      final players = ref.watch(SelectedUsersProvider(finalTop));
                                      return players.when(
                                          data: (players) {
                                            if (players.isEmpty) {
                                              return const BLText('No top players..');
                                            }
                                            if (players.length == 1) {
                                              return const BLText('You are the only player.');
                                            }
                                            return TopThreePlayers(
                                                key: ValueKey('${players[0].id}${players[1].id}'),
                                                List.generate(players.length, (i) {
                                                  return players[i].profilePicLink!;
                                                }));
                                          },
                                          error: genericError,
                                          loading: genericLoading);
                                    },
                                    error: genericError,
                                    loading: genericLoading),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        BLSmallTitle(
                          'Ranking',
                        )
                      ],
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      final scrollController = ScrollController();
                      return Column(
                        children: [
                          scores.when(
                              data: (scores) {
                                if (scores == null) {
                                  return const Center(
                                    child: BLText('No players found.'),
                                  );
                                }
                                final completed = scores[ScoreStatus.complete];
                                final incomplete = scores[ScoreStatus.incomplete];
                                final pending = scores[ScoreStatus.pending];
                                // final lists = scores.values.toList();
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (completed != null && completed.isNotEmpty)
                                        DataTable(columnSpacing: constraints.maxWidth / 13, headingRowHeight: 40, columns: const [
                                          DataColumn(label: BLText('Rank')),
                                          DataColumn(label: BLText('Player')),
                                          DataColumn(label: BLText('Time')),
                                          DataColumn(label: BLText('Score')),
                                        ], rows: [
                                          ...List.generate(completed.length, (i) {
                                            return DataRow(cells: [
                                              DataCell(BLText((i + 1).toString())),
                                              DataCell(Row(
                                                children: [
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth: constraints.maxWidth / 4),
                                                    child: Scrollbar(
                                                      controller: scrollController,
                                                      child: SingleChildScrollView(
                                                        controller: scrollController,
                                                        scrollDirection: Axis.horizontal,
                                                        clipBehavior: Clip.antiAlias,
                                                        child: BLDisplayName(
                                                          completed[i].accountID!,
                                                          AccountType.user,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              DataCell(Center(
                                                child: BLText(
                                                  formatTime(completed[i].timeElapsed!),
                                                ),
                                              )),
                                              DataCell(Center(
                                                child: BLText(
                                                  '${completed[i].playerScore}/${widget.leaderboard.totalScore}',
                                                ),
                                              )),
                                            ]);
                                          }),
                                        ]),
                                      // if (pending != null && pending.isNotEmpty)

                                      if (pending != null && pending.isNotEmpty)
                                        DataTable(columnSpacing: 8, headingRowHeight: 40, columns: const [
                                          // DataColumn(label: BLText('')),
                                          DataColumn(
                                            label: BLText(
                                              'In-game',
                                              size: 18,
                                              color: Colors.amber,
                                              bold: true,
                                            ),
                                          )
                                        ], rows: [
                                          ...List.generate(pending.length, (i) {
                                            return DataRow(cells: [
                                              DataCell(SizedBox(
                                                width: width * 0.4,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // BLProfilePic(completed[i].accountID!, type: AccountType.user),
                                                    Flexible(child: BLDisplayName(pending[i].accountID!, AccountType.user)),
                                                  ],
                                                ),
                                              )),
                                            ]);
                                          }),
                                        ]),
                                      // if (incomplete != null && incomplete.isNotEmpty)

                                      if (incomplete != null && incomplete.isNotEmpty)
                                        DataTable(columnSpacing: 8, headingRowHeight: 40, columns: const [
                                          // DataColumn(label: BLText('Player')),
                                          DataColumn(
                                            label: BLText(
                                              'Left the game',
                                              size: 18,
                                              color: Colors.deepOrange,
                                              bold: true,
                                            ),
                                          )
                                        ], rows: [
                                          ...List.generate(incomplete.length, (i) {
                                            return DataRow(cells: [
                                              DataCell(SizedBox(
                                                width: width * 0.4,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // BLProfilePic(completed[i].accountID!, type: AccountType.user),
                                                    Flexible(child: BLDisplayName(incomplete[i].accountID!, AccountType.user)),
                                                  ],
                                                ),
                                              )),
                                            ]);
                                          }),
                                        ]),
                                    ],
                                  ),
                                );
                              },
                              error: genericError,
                              loading: genericLoading)
                        ],
                      );
                    })
                  ],
                ),
              ),
              if (!widget.showBackButton)
                const SizedBox(
                  height: 10,
                ),
              if (!widget.showBackButton)
                BLButton(
                    onPressed: () async {
                      nav.pop(context);
                      int? count = sharedPref.getInt('randomDialog');
                      if (count == null || count == 0) {
                        sharedPref.setInt('randomDialog', 5);
                        await showDialog(context: context, builder: (context) => RandomDialog(count: count));
                      } else {
                        sharedPref.setInt('randomDialog', count--);
                      }
                    },
                    child: const BLText(
                      'Back to rooms',
                      color: Colors.white,
                    ))
            ],
          ),
        )),
      ),
    );
  }
}
