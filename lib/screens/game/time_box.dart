import 'dart:async';

import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TimeBox extends ConsumerStatefulWidget {
  const TimeBox({super.key});

  @override
  ConsumerState<TimeBox> createState() => _TimeBoxState();
}

class _TimeBoxState extends ConsumerState<TimeBox> {
  int seconds = 0;
  late String timeString;
  late Timer timer;
  late final GameManager gameManager;

  @override
  Widget build(BuildContext context) {
    final shouldPause = ref.watch(gameManagerProvider.select((state) => state.pauseTimer));
    if (shouldPause) {
      pauseTimer();
    } else {
      resumeTimer();
    }
    return BLBorderedPanel(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WidgetAnimator(
            atRestEffect: WidgetRestingEffects.size(effectStrength: 1, delay: Durations.extralong1),
            child: const Icon(
              FontAwesomeIcons.clock,
              size: 18,
            ),
          ),
          const SizedBox(width: 7),
          BLText(
            formatTime(seconds),
            bold: true,
          )
        ],
      ),
    ));
  }

  Timer createTimer() {
    return Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds++;
      });
      gameManager.updateTimeElapsed(seconds);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    gameManager = ref.read(gameManagerProvider.notifier);
    timer = createTimer();
    super.initState();
  }

  void pauseTimer() {
    setState(() {
      timer.cancel();
    });
  }

  void resumeTimer() {
    if (timer.isActive) {
      return;
    } else {
      setState(() {
        timer = createTimer();
      });
    }
  }
}
