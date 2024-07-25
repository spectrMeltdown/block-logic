import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/room_in_game.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/blocks_selector.dart';
import 'package:block_logic/screens/game/editor.dart';
import 'package:block_logic/screens/game/game_appbar.dart';
import 'package:block_logic/screens/game/run_btn.dart';
import 'package:block_logic/screens/game/submit_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The entire game screen
class Game extends ConsumerStatefulWidget {
  const Game(this.roomID, {super.key});
  final String roomID;

  @override
  ConsumerState<Game> createState() => _GameState();
}

class _GameState extends ConsumerState<Game> {
  @override
  Widget build(BuildContext context) {
    //TODO: have a gamehost controller that will react to host actions, like when game start
    //TODO: when game starts, display challenge and limitation overlay
    //final gameHost = ref.watch(gameHostProvider);
    final room = ref.watch(GameRoomProvider(widget.roomID));

    Widget testing() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          // TODO: change to intercept challenges & room from firestore
          GameAppbar(
              room: Room(
                  id: 'id',
                  icon: 'icon',
                  hostID: 'hostID',
                  challengeIDs: [],
                  name: 'name',
                  password: 'password',
                  capacity: 5),
              challenges: const []),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: BLMediaQuery().screenH(context) / 8.3,
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: BLMediaQuery().screenW(context) / 1.9),
                  child: BLPanel(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                BLText(
                                  'Challenge:',
                                  bold: true,
                                  color: BLUI().getAppColor('blue'),
                                ),
                                const BLText(
                                    'Check if the given year is a leap year.',
                                    size: 14),
                                BLText(
                                  'Limitations:',
                                  bold: true,
                                  color: BLUI().getAppColor('orange'),
                                ),
                                const BLText('- One tab only', size: 14),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: BLMediaQuery().screenW(context) / 2.9),
                  child: const Column(
                    children: [
                      GameSubmitButton(),
                      SizedBox(height: 10),
                      GameRunButton(),
                    ],
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(height: 10),
          const BlockDropOff(),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 20), child: GameBlocks()),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Background(
          child: room.when(
        data: (room) {
          return testing();
          // if (room == null) return const BLError();
          // return const Column(
          //   children: [
          //     SizedBox(height: 20),
          //     Row(
          //       children: [
          //         BLBorderedPanel(Icon(FontAwesomeIcons.pause)),
          //       ],
          //     ),
          //   ],
          // );
        },
        error: (error, stackTrace) {
          return testing();
        },
        loading: () {
          return const BLLoading();
        },
      )),
    );
  }
}
