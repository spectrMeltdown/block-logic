import 'package:flutter/material.dart';

class BLSwitch extends StatefulWidget {
  const BLSwitch({super.key, required this.state, required this.onPressed});
  final VoidCallback onPressed;
  final bool state;

  @override
  State<BLSwitch> createState() => _BLSwitchState();
}

class _BLSwitchState extends State<BLSwitch> {
  bool state = false;

  @override
  void initState() {
    state = widget.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: state,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() {
          state = value;
        });
        widget.onPressed.call();
      },
    );
  }
}

class BGSlider extends StatefulWidget {
  const BGSlider({super.key});

  @override
  State<BGSlider> createState() => _BGSliderState();
}

class _BGSliderState extends State<BGSlider> {
  @override
  Widget build(BuildContext context) {
    double currentSliderstate = 20;

    return Slider(
      value: currentSliderstate,
      max: 100,
      divisions: 5,
      label: currentSliderstate.round().toString(),
      onChanged: (double value) {
        setState(() {
          currentSliderstate = value;
        });
      },
    );
  }
}
