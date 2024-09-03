import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_providers/all_scores.dart';
import 'package:block_logic/logic/firebase_providers/selected_users.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/leaderboard/selected_leaderboard_item.dart';
import 'package:block_logic/screens/leaderboard/top_three_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SelectedLeaderboard extends ConsumerStatefulWidget {
  final Leaderboard leaderboard;
  final String roomPhotoURL;
  final String roomTitle;
  const SelectedLeaderboard(this.leaderboard, {required this.roomPhotoURL, required this.roomTitle, super.key});

  @override
  ConsumerState<SelectedLeaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends ConsumerState<SelectedLeaderboard> {
  final double horizontalPadding = 10;
  late final BLUI blui;
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(SelectedUsersProvider(widget.leaderboard.players!));
    final scores = ref.watch(AllScoresProvider(widget.leaderboard.id!));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          const Align(alignment: Alignment.centerLeft, child: BLBackButton()),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BLCircular(
                              url: widget.roomPhotoURL,
                              iconSize: 25,
                            ),
                            const SizedBox(width: 8),
                            BLText(widget.roomTitle, size: 18),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BLText(
                              DateFormat('MMMM d, yyyy').format(widget.leaderboard.date!),
                              color: Colors.amber,
                              size: 12,
                            ),
                            BLText(
                              DateFormat('h:mm a').format(widget.leaderboard.date!),
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
                          scores.when(
                              data: (scores) {
                                if (scores != null) {
                                  return const Center(child: BLText('No players found.'));
                                }
                                return players.when(
                                    data: (players) {
                                      if (players == null) {
                                        return const Center(child: BLText('No players found.'));
                                      }
                                      return TopThreePlayers(List.generate(players.length, (i) {
                                        return players[i].profilePicLink!;
                                      }));
                                    },
                                    error: genericError,
                                    loading: genericLoading);
                              },
                              error: genericError,
                              loading: genericLoading)
                        ],
                      ),
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: BLSmallTitle(
                          'Ranking',
                          color: Colors.amber,
                        )),
                    const Row(
                      children: [
                        BLText('Rank'),
                        SizedBox(width: 30),
                        BLText('Player'),
                        SizedBox(width: 30),
                        BLText('Time')
                      ],
                    )
                  ]),
                ),
                Column(
                  children: [
                    Expanded(
                      child: scores.when(
                          data: (scores) {
                            if (scores == null) {
                              return const Center(
                                child: BLText('No players found!'),
                              );
                            }
                            final completed = scores[ScoreStatus.complete];
                            final incomplete = scores[ScoreStatus.incomplete];
                            final pending = scores[ScoreStatus.pending];
                            final lists = scores.values.toList();
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: (lists[0].length + lists[1].length + lists[2].length),
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    ...List.generate(completed!.length, (i) {
                                      return SelectedLeaderboardItem(
                                        rank: i,
                                        playerUID: completed[i].id!,
                                        time: DateTime.fromMillisecondsSinceEpoch(completed[i].timeElapsed!),
                                        score: completed[i].playerScore!,
                                      );
                                    }),
                                    const BLText('Pending'),
                                    ...List.generate(pending!.length, (i) {
                                      return SelectedLeaderboardItem(
                                        rank: i,
                                        playerUID: pending[i].id!,
                                        time: DateTime.fromMillisecondsSinceEpoch(pending[i].timeElapsed!),
                                        score: pending[i].playerScore!,
                                      );
                                    }),
                                    const BLText('Incomplete'),
                                    ...List.generate(incomplete!.length, (i) {
                                      return SelectedLeaderboardItem(
                                        rank: i,
                                        playerUID: incomplete[i].id!,
                                        time: DateTime.fromMillisecondsSinceEpoch(incomplete[i].timeElapsed!),
                                        score: incomplete[i].playerScore!,
                                      );
                                    }),
                                  ],
                                );
                              },
                            );
                          },
                          error: genericError,
                          loading: genericLoading),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  void initState() {
    blui = ref.read(bLUIProvider.notifier);
    super.initState();
  }
}
