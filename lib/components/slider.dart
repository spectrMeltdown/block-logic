import 'package:flutter/material.dart';

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
