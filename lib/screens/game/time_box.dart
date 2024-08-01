import 'dart:async';

import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TimeBox extends ConsumerStatefulWidget {
  const TimeBox(this.pauseTimer, {super.key});
  final bool pauseTimer;

  @override
  ConsumerState<TimeBox> createState() => _TimeBoxState();
}

class _TimeBoxState extends ConsumerState<TimeBox> {
  int seconds = 0;
  late String timeString;
  late Timer timer;
  late GameManagerState gameManagerState;

  @override
  void initState() {
    timer = createTimer();
    gameManagerState = ref.read(gameManagerStateProvider.notifier);
    super.initState();
  }

  Timer createTimer() {
    return Timer.periodic(const Duration(seconds: 1), (Timer t) {
      seconds++;
      setState(() {});
    });
  }

  void pauseTimer() {
    timer.cancel();
  }

  void resumeTimer() {
    if (timer.isActive) {
      return;
    } else {
      timer = createTimer();
    }
  }

  String formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pauseTimer) {
      pauseTimer();
    } else {
      resumeTimer();
    }
    return BLBorderedPanel(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          WidgetAnimator(
            atRestEffect: WidgetRestingEffects.size(
                effectStrength: 1, delay: Durations.extralong1),
            child: const Icon(
              FontAwesomeIcons.clock,
              size: 18,
            ),
          ),
          const SizedBox(width: 7),
          BLText(
            formatTime(seconds),
            animated: false,
            size: 16,
            bold: true,
          )
        ],
      ),
    ));
  }
}
