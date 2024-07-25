import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/screens/game/pause_dialog.dart';
import 'package:block_logic/screens/game/time_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// The in-game appbar that consists of:
/// - pause button
/// - challenge title
/// - room title
/// - time box (track elapsed time)
class GameAppbar extends ConsumerStatefulWidget {
  const GameAppbar({required this.room, required this.challenges, super.key});
  final Room room;
  final List<Challenge> challenges;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameAppbarState();
}

class _GameAppbarState extends ConsumerState<GameAppbar> {
  late final BLAudioState audio;
  bool pauseTimer = false;

  @override
  void initState() {
    audio = ref.read(bLAudioStateProvider.notifier);
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: change to challenges later
            BLText(
                widget.challenges.isEmpty
                    ? 'Challenge Name'
                    : widget.challenges.first.name ?? 'Challenge Name',
                bold: true,
                size: 20),
            BLText(
              widget.room.name ?? 'Room Name',
              bold: true,
              size: 13,
              color: Colors.grey,
            ),
          ],
        ),
        TimeBox(pauseTimer),
      ],
    );
  }
}
