import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final BtnType type;
  final EdgeInsets? padding;
  final double? paddingX;
  final double? paddingY;
  const BLButton(
      {required this.onPressed,
      required this.child,
      this.type = BtnType.normal,
      this.padding,
      this.paddingX,
      this.paddingY,
      super.key});

  @override
  ConsumerState<BLButton> createState() => _BtnState();
}

class _BtnState extends ConsumerState<BLButton> {
  BLAudioState? audio;
  late final BLUI blui;
  bool _isTapped = false;
  late List<Color> btnPressedColor;
  late List<Color> btnColor;
  final Color darkerShade = Colors.blueGrey.shade900;
  final Color darkShade = Colors.blueGrey.shade800;
  final containerKey = GlobalKey();
  double width = 10;
  final List<BoxShadow> btnShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 20,
      offset: const Offset(0, 0),
    )
  ];

  @override
  Widget build(BuildContext context) {
    getBtnColor();
    return GestureDetector(
      onTapDown: (details) {
        audio?.playBtn();
        _onTapDown();
      },
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
          key: containerKey,
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: widget.paddingX ?? 30, vertical: widget.paddingY ?? 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.white, width: 2.0),
            gradient:
                RadialGradient(colors: _isTapped ? btnPressedColor : btnColor, radius: blui.getRadius(context, width)),
            boxShadow: (_isTapped ? btnShadow : null),
          ),
          child: widget.child),
    );
  }

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
      case BtnType.orange:
        btnPressedColor = [Colors.deepOrange, darkerShade];
        btnColor = [Colors.deepOrange.shade600, darkerShade];
        break;
      case BtnType.green:
        btnPressedColor = [Colors.greenAccent.shade700, darkerShade];
        btnColor = [Colors.green.shade800, darkerShade];
        break;
      case BtnType.grey:
        btnPressedColor = [Colors.grey.shade300, darkerShade];
        btnColor = [Colors.grey.shade800, darkerShade];
        break;
    }
  }

  @override
  void initState() {
    if (!kIsWeb) audio = ref.read(bLAudioStateProvider.notifier);
    blui = ref.read(bLUIProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the width after the first frame is rendered
      final RenderBox renderBox = containerKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        width = renderBox.size.width;
      });
    });
    super.initState();
  }

  void _onTapCancel() {
    setState(() {
      _isTapped = false;
    });
  }

  void _onTapDown() {
    setState(() {
      _isTapped = true;
    });
  }

  void _onTapUp(TapUpDetails tapUp) {
    setState(() {
      _isTapped = false;
    });
    widget.onPressed.call();
  }
}
