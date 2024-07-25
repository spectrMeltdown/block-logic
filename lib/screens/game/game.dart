import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_providers/room_in_game.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/block_selector.dart';
import 'package:block_logic/screens/game/editor.dart';
import 'package:block_logic/screens/game/pause_dialog.dart';
import 'package:block_logic/screens/game/run_btn.dart';
import 'package:block_logic/screens/game/submit_btn.dart';
import 'package:block_logic/screens/game/time_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Game extends ConsumerStatefulWidget {
  const Game(this.roomID, {super.key});
  final String roomID;

  @override
  ConsumerState<Game> createState() => _GameState();
}

class _GameState extends ConsumerState<Game> {
  bool pauseTimer = false;

  @override
  Widget build(BuildContext context) {
    //TODO: have a gamehost controller that will react to host actions, like when game start
    //TODO: when game starts, display challenge and limitation overlay
    //final gameHost = ref.watch(gameHostProvider);
    final room = ref.watch(GameRoomProvider(widget.roomID));
    final audio = ref.read(bLAudioStateProvider.notifier);
    void pauseMenu(TapUpDetails tap) async {
      audio.playBtn();
      pauseTimer = true;
      setState(() {});
      await showGeneralDialog(
          context: context,
          barrierDismissible: false,
          transitionDuration: const Duration(milliseconds: 500),
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            final primaryCurve = CurvedAnimation(
              parent: animation,
              //     begin: const Offset(0, 1),
              //     end: const Offset(0, 0),
              //   ).animate(animation),
              //   child: child,
              // );
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(primaryCurve),
              child: child,
            );
            // return SlideTransition(
            //   position: Tween<Offset>(
          },
          pageBuilder: (context, animation1, animation2) {
            return const PauseDialog();
          });
      pauseTimer = false;
      setState(() {});
    }

    Widget testing() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTapUp: pauseMenu,
                child: const BLBorderedPanel(
                  Icon(
                    FontAwesomeIcons.pause,
                    size: 20,
                  ),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BLText('Challenge Name', bold: true, size: 20),
                  BLText(
                    'Room Name',
                    bold: true,
                    size: 13,
                    color: Colors.grey,
                  ),
                ],
              ),
              TimeBox(pauseTimer),
            ],
          ),
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
          const SizedBox(height: 10),
          const GameBlocks()
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
