import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:block_logic/logic/game/logic/game_provider.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/game/logic/time_box.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/game/pause_dialog.dart';
import 'package:block_logic/screens/game/time_box.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';

/// The in-game appbar that consists of:
/// - pause button
/// - challenge title
/// - room title
/// - time box (track elapsed time)
class GameAppbar extends ConsumerWidget {
  final String roomName;
  final Challenge challenge;
  final int currentIndex;
  final int maxIndex;
  final bool practiceMode;
  const GameAppbar({
    required this.roomName,
    required this.challenge,
    required this.currentIndex,
    required this.maxIndex,
    required this.practiceMode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    final dialog = ref.read(dialogServiceProvider.notifier);
    final audio = ref.read(bLAudioStateProvider.notifier);
    final gameManager = ref.read(gameManagerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTapDown: (details) => audio.playBtn(),
          onTapUp: (details) async {
            if (!practiceMode) {
              gameManager.pauseTimer();
              ref.invalidate(runTimerProvider);
            }

            // dPrint('pause timer: ${gameManager.getTimer()}');
            bool result = false;
            final leave = await dialog.show(context, const PauseDialog());
            if (leave is bool && leave) {
              if (practiceMode) {
                gameManager.resetTree();
                // gameManager.setShouldResetAllBlocks(true);
                ref.invalidate(getRootDataProvider);
                // ref.invalidate(shouldResetAllBlocksProvider);
                // ref.invalidate(gameManagerProvider);
                if (!context.mounted) return;
                nav.pop(context);
                nav.pop(context);
                return;
              }
              if (!context.mounted) return;
              result = await showDialog(context: context, builder: (context) => const ConfirmDialog()) ?? false;
              if (result) {
                final value = await gameManager.leaveGame(false);
                dPrint(value);
                gameManager.resetTree();
                ref.invalidate(getRootDataProvider);
                // ref.invalidate(gameManagerProvider);
                // gameManager.setShouldResetAllBlocks(true);
                // ref.invalidate(shouldResetAllBlocksProvider);
                // ref.invalidate(shouldResetBlockProvider);

                final assets = ref.read(assetsProvider);
                final sharedPref = ref.read(sharedPrefProvider);

                /// check if a backgroundMusic setting exists
                final backgroundMusic = sharedPref.getBool('backgroundMusic');
                if (backgroundMusic == null || backgroundMusic == true) {
                  /// initialize the audio
                  FlameAudio.bgm.play(assets.audioBG1);
                } else {
                  /// play silently to load the track
                  FlameAudio.bgm.play(assets.audioBG1, volume: 0);

                  /// pause after track loaded
                  FlameAudio.bgm.pause();
                }
                if (!context.mounted) return;
                nav.pop(context);
              }
            }
            if (!practiceMode) {
              gameManager.resumeTimer();
              ref.invalidate(runTimerProvider);
            }

            // dPrint('pause timer: ${gameManager.getTimer()}');
          },
          child: const BLBorderedPanel(
            child: Icon(
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
        Expanded(child: TimeBox(practiceMode)),
      ],
    );
  }

  Widget buildText([bool isChallenge = false]) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final text = isChallenge
            ? challenge.name
            : maxIndex > 1
                ? '$roomName (${currentIndex + 1} / $maxIndex)'
                : roomName;
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
              text ?? '',
              bold: true,
              size: 20,
            );
          }
          // if room name
          return BLText(
            text ?? '',
            bold: true,
            size: 13,
            color: Colors.grey,
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height / 35,
          child: Marquee(
            text: text ?? '',
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
}
