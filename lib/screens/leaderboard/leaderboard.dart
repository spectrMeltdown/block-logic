import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/leaderboard.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/firebase_providers/all_scores.dart';
import 'package:block_logic/logic/firebase_providers/selected_users.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/leaderboard/leaderboard_item.dart';
import 'package:block_logic/screens/leaderboard/top_three_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaderboardWidget extends ConsumerStatefulWidget {
  final Leaderboard leaderboard;
  final String roomPhotoURL;
  final String roomTitle;
  const LeaderboardWidget(this.leaderboard, {required this.roomPhotoURL, required this.roomTitle, super.key});

  @override
  ConsumerState<LeaderboardWidget> createState() => _LeaderboardState();
}

class _LeaderboardState extends ConsumerState<LeaderboardWidget> {
  final double horizontalPadding = 10;
  late final BLUI blui;
  @override
  void initState() {
    blui = ref.read(bLUIProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scores = ref.watch(AllScoresProvider(widget.leaderboard.id!));
    final players = ref.watch(SelectedUsersProvider(widget.leaderboard.players!));
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 50),
                      child: Column(
                        children: [
                          BLSmallTitle(
                            'Top players',
                            color: Colors.amber,
                          ),
                          TopThreePlayers(['', '', '']),
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
                      child: users.when(
                          data: (users) {
                            if (users == null) {
                              return const Center(
                                child: BLText('No players found!'),
                              );
                            }
                            final testingPlayers = [
                              UserAccount(
                                displayName: 'Jonathan',
                                profilePicLink: '',
                              ),
                              UserAccount(
                                displayName: 'Aljon',
                                profilePicLink: '',
                              ),
                              UserAccount(
                                displayName: 'Rizell',
                                profilePicLink: '',
                              )
                            ];
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: testinglist.length,
                              itemBuilder: (context, i) {
                                return LeaderboardWidgetItem(rank: 1, user: user, time: time);
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
}
