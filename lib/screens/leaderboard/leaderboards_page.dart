import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
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
  @override
  Widget build(BuildContext context) {
    final userLeaderboards = ref.watch(SelectedUserLeaderboardsProvider(auth.getUID()));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: userLeaderboards.when(
              data: (leaderboards) {
                if (leaderboards.isEmpty) {
                  return const Center(
                    child: BLText('No leaderboards found.'),
                  );
                }
                return ListView.builder(
                  itemCount: leaderboards.length,
                  itemBuilder: (context, i) {
                    return LeaderboardItem(leaderboards[i]);
                  },
                );
              },
              error: genericError,
              loading: genericLoading)),
    );
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }
}
