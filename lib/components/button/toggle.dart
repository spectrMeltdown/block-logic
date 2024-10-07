import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLSwitch extends ConsumerStatefulWidget {
  final void Function(bool newValue) onPressed;
  final bool state;
  const BLSwitch({super.key, required this.state, required this.onPressed});

  @override
  ConsumerState<BLSwitch> createState() => _BLSwitchState();
}

class _BLSwitchState extends ConsumerState<BLSwitch> {
  bool state = false;

  @override
  Widget build(BuildContext context) {
    BLAudioState? audio;
    if (!kIsWeb) {
      ref.watch(bLAudioStateProvider);
      audio = ref.read(bLAudioStateProvider.notifier);
    }
    return Switch(
      value: state,
      activeColor: Colors.green,
      onChanged: (bool value) {
        audio?.playBtn();
        widget.onPressed.call(value);
        setState(() {
          state = value;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    state = widget.state;
  }
}
