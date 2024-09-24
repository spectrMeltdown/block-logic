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
import 'package:block_logic/logic/firebase_providers/all_scores.dart';
import 'package:block_logic/logic/firebase_providers/selected_users.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/leaderboard/top_three_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

class _LeaderboardState extends ConsumerState<SelectedLeaderboard> {
  final double horizontalPadding = 10;
  late final BLUI blui;
  late final CustomNavigation nav;

  String formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final players = ref.watch(SelectedUsersProvider(widget.leaderboard.players!));
    final scores = ref.watch(AllScoresProvider(widget.leaderboard.id!));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
        child: Column(
          children: [
            if (widget.showBackButton) const Align(alignment: Alignment.centerLeft, child: BLBackButton()),
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
                          Row(
                            children: [
                              // BLCircular(
                              //   url: widget.roomPhotoURL,
                              //   iconSize: 25,
                              // ),
                              // const SizedBox(width: 8),
                              BLText(
                                widget.leaderboard.roomName!,
                                size: 16,
                                overflow: false,
                              ),
                            ],
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
                                    if (scores == null) {
                                      return const BLText('Players not found.');
                                    }
                                    return players.when(
                                        data: (players) {
                                          if (players == null) {
                                            return const BLText('No players found.');
                                          }
                                          if (players.length == 1) {
                                            return const BLText('You are the only player.');
                                          }
                                          return TopThreePlayers(List.generate(players.length, (i) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (completed != null && completed.isNotEmpty)
                                      DataTable(columnSpacing: constraints.maxWidth / 10, headingRowHeight: 40, columns: const [
                                        DataColumn(label: BLText('Rank')),
                                        DataColumn(label: BLText('Player')),
                                        DataColumn(label: BLText('Time')),
                                        DataColumn(label: BLText('Score')),
                                      ], rows: [
                                        ...List.generate(completed.length, (i) {
                                          return DataRow(cells: [
                                            DataCell(BLText((i + 1).toString())),
                                            DataCell(BLDisplayName(completed[i].accountID!, AccountType.user)),
                                            DataCell(Center(
                                              child: BLText(
                                                formatTime(completed[i].timeElapsed!),
                                              ),
                                            )),
                                            DataCell(Center(
                                              child: BLText(
                                                completed[i].playerScore.toString(),
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
                              // return ListView.builder(
                              //   shrinkWrap: true,
                              //   padding: EdgeInsets.zero,
                              //   itemCount: (lists[0].length + lists[1].length + lists[2].length),
                              //   itemBuilder: (context, i) {
                              //     return Column(
                              //       children: [

                              //         const BLText('Pending'),
                              //         ...List.generate(pending!.length, (i) {
                              //           return SelectedLeaderboardItem(
                              //             rank: i,
                              //             playerUID: pending[i].id!,
                              //             time: DateTime.fromMillisecondsSinceEpoch(pending[i].timeElapsed!),
                              //             score: pending[i].playerScore!,
                              //           );
                              //         }),
                              //         const BLText('Incomplete'),
                              //         ...List.generate(incomplete!.length, (i) {
                              //           return SelectedLeaderboardItem(
                              //             rank: i,
                              //             playerUID: incomplete[i].id!,
                              //             time: DateTime.fromMillisecondsSinceEpoch(incomplete[i].timeElapsed!),
                              //             score: incomplete[i].playerScore!,
                              //           );
                              //         }),
                              //       ],
                              //     );
                              //   },
                              // );
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
                  onPressed: () {
                    nav.pop(context, 'feedback');
                  },
                  child: const BLText(
                    'Back to rooms',
                    color: Colors.white,
                  ))
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    blui = ref.read(bLUIProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }
}
