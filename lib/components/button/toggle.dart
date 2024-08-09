import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLSwitch extends ConsumerStatefulWidget {
  const BLSwitch({super.key, required this.state, required this.onPressed});
  final void Function(bool newValue) onPressed;
  final bool state;

  @override
  ConsumerState<BLSwitch> createState() => _BLSwitchState();
}

class _BLSwitchState extends ConsumerState<BLSwitch> {
  bool state = false;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bLAudioStateProvider);
    final audio = ref.read(bLAudioStateProvider.notifier);
    return Switch(
      value: state,
      activeColor: Colors.green,
      onChanged: (bool value) {
        audio.playBtn();
        widget.onPressed.call(value);
        setState(() {
          state = value;
        });
      },
    );
  }
}
