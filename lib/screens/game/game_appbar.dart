import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/pause_dialog.dart';
import 'package:block_logic/screens/game/time_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';

/// The in-game appbar that consists of:
/// - pause button
/// - challenge title
/// - room title
/// - time box (track elapsed time)
class GameAppbar extends ConsumerStatefulWidget {
  const GameAppbar(
      {required this.roomName,
      required this.challengeName,
      required this.challengesCount,
      super.key});
  final String roomName;
  final String challengeName;
  final int challengesCount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameAppbarState();
}

class _GameAppbarState extends ConsumerState<GameAppbar> {
  late final BLAudioState audio;
  //late bool pauseTimer;
  late final GameManagerState gameManagerState;
  late final DialogService pauseDialog;

  @override
  void initState() {
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    pauseDialog = ref.read(dialogServiceStateProvider);
    audio = ref.read(bLAudioStateProvider.notifier);
    super.initState();
  }

  Widget buildText([bool isChallenge = false]) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final text = kDebugMode
            ?
            //'This is to text the scrollable text widget'
            'This is short'
            : isChallenge
                ? widget.challengeName
                : widget.roomName;
        final roomStyle = TextStyle(
          fontWeight: FontWeight.bold,
          color: BLUI().getAppColor('lightBlue'),
          fontSize: 16,
        );
        const challengeStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        );
        final style = isChallenge ? challengeStyle : roomStyle;
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: 0, maxWidth: constraints.maxWidth);
        // if an overflow did not occur, set fixed sized text widget
        if (!textPainter.didExceedMaxLines) {
          // if challenge name
          if (isChallenge) {
            return BLText(
              text,
              bold: true,
              size: 20,
            );
          }
          // if room name
          return BLText(
            text,
            bold: true,
            size: 13,
            color: Colors.grey,
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height / 35,
          child: Marquee(
            text: text,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 15.0,
            velocity: 100.0,
            pauseAfterRound: const Duration(seconds: 5),
            accelerationDuration: const Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = ref.watch(gameManagerStateProvider);
    debugPrint('pause timer: ${gameManager.pauseTimer}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTapDown: (details) => audio.playBtn(),
          onTapUp: (details) async {
            gameManagerState.pauseTimer();
            await pauseDialog.showDialog(context, dialog: const PauseDialog());
            gameManagerState.resumeTimer();
          },
          child: const BLBorderedPanel(
            Icon(
              FontAwesomeIcons.pause,
              size: 20,
            ),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildText(true), buildText()],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: TimeBox(gameManager.pauseTimer)),
      ],
    );
  }
}
