import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLCard extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets innerPadding;
  final EdgeInsets outerPadding;
  final Color color;
  final Color? darkShade;
  final List<BoxShadow>? glow;
  final List<BoxShadow>? pressedOverlayColor;
  final double? height;
  final double? width;
  const BLCard({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
    this.glow,
    this.height,
    this.width,
    this.pressedOverlayColor,
    this.darkShade,
    this.outerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.innerPadding =
        const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
  });

  @override
  ConsumerState<BLCard> createState() => _BLCardState();
}

class _BLCardState extends ConsumerState<BLCard> {
  bool _isTapped = false;
  late final List<Color> colorPressed;
  late final List<Color> color;
  double width = 10;
  final containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final audio = ref.read(bLAudioStateProvider.notifier);
    final blui = ref.read(bLUIProvider);
    return Container(
      padding: widget.outerPadding,
      child: GestureDetector(
        onTapDown: (details) {
          audio.playBtn();
          _onTapDown();
        },
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
            key: containerKey,
            width: widget.width,
            height: widget.height,
            padding: widget.innerPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white, width: 3.0),
              gradient: RadialGradient(
                  colors: _isTapped ? colorPressed : color,
                  radius: blui.getRadius(context, width)),
              boxShadow: (_isTapped
                  ? <BoxShadow>[
                      ...widget.pressedOverlayColor ?? [],
                      ...widget.glow ??
                          [
                            BoxShadow(
                              color:
                                  widget.color.brighten(0.4).withOpacity(0.8),
                              spreadRadius: -20,
                              blurRadius: 10,
                            )
                          ],
                    ]
                  : null),
            ),
            child: widget.child),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the width after the first frame is rendered
      final RenderBox renderBox =
          containerKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        width = renderBox.size.width;
      });
    });
    final darkShade = widget.darkShade ?? widget.color.darken(0.4);
    color = [widget.color, darkShade];
    colorPressed = [widget.color.brighten(0.2), darkShade];
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
