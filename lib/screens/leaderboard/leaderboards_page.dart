import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/selected_user_leaderboards.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/screens/leaderboard/leaderboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardsPage extends ConsumerStatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends ConsumerState<LeaderboardsPage> {
  late final AuthService auth;
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final userLeaderboards = ref.watch(SelectedUserLeaderboardsProvider(auth.getUID()));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: BLBackButton(),
            ),
            const BLSmallTitle('Leaderboards'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: BLBorderedPanel(
                  child: userLeaderboards.when(
                      data: (leaderboards) {
                        if (leaderboards.isEmpty) {
                          return const SizedBox.expand(
                            child: Center(
                              child: BLText('No leaderboards found.'),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: leaderboards.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: LeaderboardItem(leaderboards[i]),
                            );
                          },
                        );
                      },
                      error: genericError,
                      loading: genericLoading),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }
}
