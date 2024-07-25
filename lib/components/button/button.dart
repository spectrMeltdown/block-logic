import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLButton extends ConsumerStatefulWidget {
  const BLButton(
      {required this.onPressed,
      required this.child,
      this.type = BtnType.normal,
      this.padding,
      super.key});
  final VoidCallback onPressed;
  final Widget child;
  final BtnType type;
  final EdgeInsets? padding;

  @override
  ConsumerState<BLButton> createState() => _BtnState();
}

class _BtnState extends ConsumerState<BLButton> {
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

  void _onTapUp(TapUpDetails tapUp) {
    setState(() {
      _isTapped = false;
    });
    widget.onPressed.call();
  }

  void _onTapDown() {
    setState(() {
      _isTapped = true;
    });
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
    final audio = ref.read(bLAudioStateProvider.notifier);
    return GestureDetector(
      onTapDown: (details) {
        audio.playBtn();
        _onTapDown();
      },
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.white, width: 2.0),
            gradient: RadialGradient(
                colors: _isTapped ? btnPressedColor : btnColor,
                radius:
                    (widget.padding != null) ? getRadius(widget.padding) : 3),
            boxShadow: (_isTapped ? btnShadow : null),
          ),
          child: widget.child),
    );
  }
}
