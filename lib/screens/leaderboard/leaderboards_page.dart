import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/help.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/selected_user_leaderboards.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/leaderboard_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/leaderboard/leaderboard_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardsPage extends ConsumerStatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends ConsumerState<LeaderboardsPage> {
  late final AuthService auth;
  late final LeaderboardManager manager;
  late final Toast toast;
  final scrollController = ScrollController();
  final Map<String, List<String>> selectedLeaderboards = {};
  bool deleteMode = false;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final userLeaderboards = ref.watch(SelectedUserLeaderboardsProvider(auth.getUID()));
    return PopScope(
      canPop: !processing,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
            child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BLBackButton(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => const BLHelpDialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BLText(
                                              'Usage',
                                              bold: true,
                                            ),
                                            BLText(
                                              'Long-press - Delete leaderboards.',
                                              softWrap: true,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ));
                            },
                            icon: const Icon(FontAwesomeIcons.circleQuestion)),
                      ),
                    ],
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
                              leaderboards = leaderboards.reversed.toList();
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: leaderboards.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: LeaderboardItem(
                                      leaderboards[i],
                                      deleteMode: deleteMode,
                                      updateDeleteMode: updateDeleteMode,
                                      updateList: updateList,
                                    ),
                                  );
                                },
                              );
                            },
                            error: genericError,
                            loading: genericLoading),
                      ),
                    ),
                  ),
                  if (deleteMode)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BLTextButton(
                            onPressed: () {
                              updateDeleteMode();
                              setState(() {
                                selectedLeaderboards.clear();
                              });
                            },
                            child: const BLText(
                              'Cancel',
                              bold: true,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        BLTextButton(
                            onPressed: () {
                              if (processing) return;
                              setState(() {
                                processing = true;
                              });
                              if (selectedLeaderboards.isNotEmpty) {
                                for (final entry in selectedLeaderboards.entries) {
                                  manager.updatePlayers(entry.key, {
                                    'players': FieldValue.arrayRemove(entry.value),
                                  });
                                }
                              }
                              updateDeleteMode();
                              setState(() {
                                processing = false;
                              });
                            },
                            child: const BLText(
                              'Delete',
                              bold: true,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
            if (processing)
              Container(
                color: Colors.black.withOpacity(0.9),
                child: const BLLoading(
                  message: 'Processing ...',
                ),
              )
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    manager = ref.read(leaderboardManagerProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }

  void updateList(String leadID, String uid, bool add) {
    if (add) {
      setState(() {
        // if leaderboard id exists
        if (selectedLeaderboards.keys.any((key) => key == leadID)) {
          selectedLeaderboards[leadID]!.add(uid);
        } else {
          selectedLeaderboards.addAll({
            leadID: [uid]
          });
        }
      });
    } else {
      setState(() {
        selectedLeaderboards[leadID]!.removeWhere((i) => i == uid);
      });
    }
  }

  void updateDeleteMode() {
    setState(() {
      deleteMode = !deleteMode;
    });
  }
}
