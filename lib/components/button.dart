import 'package:block_logic/logic/audio.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:flutter/material.dart';

enum BtnType {
  normal,
  green,
  red,
}

/*
// Load a Lottie file from your assets
Lottie.asset('assets/LottieLogo1.json'),

// Load a Lottie file from a remote url
Lottie.network(
    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),

// Load an animation and its images from a zip file
Lottie.asset('assets/lottiefiles/angel.zip')


ADVANCED ANIMATION CONTROL

late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..value = 0.5
      ..addListener(() {
        setState(() {
          // Rebuild the widget at each frame to update the "progress" label.
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

   Lottie.asset(
              'assets/LottieLogo1.json',
              controller: _controller,
              height: 300,
              onLoaded: (composition) {
                setState(() {
                  _controller.duration = composition.duration;
                });
              },
            ),
            Text(_controller.value.toStringAsFixed(2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play backward
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () {
                    _controller.reverse();
                  },
                ),
                // Pause
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () {
                    _controller.stop();
                  },
                ),
                // Play forward
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    _controller.forward();
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Loop between 2 specifics frames

                var start = 0.1;
                var stop = 0.5;
                _controller.repeat(
                  min: start,
                  max: stop,
                  reverse: true,
                  period: _controller.duration! * (stop - start),
                );
              },
              child: const Text('Loop between frames'),
            ),

*/

class BLButton extends StatefulWidget {
  const BLButton({required this.onPressed, required this.child, this.type = BtnType.normal, this.padding, super.key});
  final VoidCallback onPressed;
  final Widget child;
  final BtnType type;
  final EdgeInsets? padding;

  @override
  State<BLButton> createState() => _BtnState();
}

class _BtnState extends State<BLButton> {
  bool _isTapped = false;
  late List<Color> btnPressedColor;
  late List<Color> btnColor;
  final Color darkerShade = Colors.blueGrey.shade900;
  final Color darkShade = Colors.blueGrey.shade800;
  final List<BoxShadow> btnShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 20,
      offset: const Offset(0, 0),
    )
  ];

  void getBtnColor() {
    switch (widget.type) {
      case BtnType.normal:
        btnPressedColor = [Colors.teal.shade300, darkerShade];
        btnColor = [Colors.teal.shade800, darkerShade];
        break;
      case BtnType.red:
        btnPressedColor = [Colors.red, darkerShade];
        btnColor = [Colors.redAccent.shade700, darkerShade];
        break;
      case BtnType.green:
        btnPressedColor = [Colors.greenAccent[700]!, darkerShade];
        btnColor = [Colors.green[800]!, darkerShade];
        break;
    }
  }

  void _onTapUp(TapUpDetails tapUp) {
    setState(() {
      _isTapped = false;
    });
    widget.onPressed.call();
    Utils.assertFunc(getBtnColor);
  }

  void _onTapDown(TapDownDetails tapDown) {
    setState(() {
      _isTapped = true;
    });
    BLAudio.playBtn();
  }

  void _onTapCancel() {
    setState(() {
      _isTapped = false;
    });
  }

  @override
  void initState() {
    getBtnColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.white, width: 2.0),
            gradient: RadialGradient(
                colors: _isTapped ? btnPressedColor : btnColor,
                radius: (widget.padding != null) ? getRadius(widget.padding) : 3),
            boxShadow: (_isTapped ? btnShadow : null),
          ),
          child: widget.child),
    );
  }
}

// get gradient radius based on padding provided
double getRadius(EdgeInsets? padding) {
  double defaultRadius = 2;
  if (padding == null) return defaultRadius;
  if (padding.left >= 40 || padding.right >= 40) {
    return 3;
  } else {
    return defaultRadius;
  }
}
