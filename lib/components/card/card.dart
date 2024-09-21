import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/color.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLCard extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final EdgeInsets innerPadding;
  final EdgeInsets outerPadding;
  final Color color;
  final Color? darkShade;
  final List<BoxShadow>? glow;
  final List<BoxShadow>? pressedOverlayColor;
  final double? height;
  final double? width;
  final Color? borderColor;
  const BLCard({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
    this.borderColor,
    this.glow,
    this.onLongPress,
    this.height,
    this.width,
    this.pressedOverlayColor,
    this.darkShade,
    this.outerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
  });

  @override
  ConsumerState<BLCard> createState() => _BLCardState();
}

class _BLCardState extends ConsumerState<BLCard> {
  bool _isTapped = false;
  late final BLAudioState audio;
  late final BLUI blui;
  late final List<Color> colorPressed;
  late final List<Color> color;
  double width = 10;
  final containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.outerPadding,
      child: GestureDetector(
        onLongPress: widget.onLongPress,
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
              border: Border.all(color: widget.borderColor ?? Colors.white, width: 3.0),
              gradient: RadialGradient(colors: _isTapped ? colorPressed : color, radius: blui.getRadius(context, width)),
              boxShadow: (_isTapped
                  ? <BoxShadow>[
                      ...widget.pressedOverlayColor ?? [],
                      ...widget.glow ??
                          [
                            BoxShadow(
                              color: widget.color.brighten(0.3).withOpacity(0.6),
                              spreadRadius: 0,
                              blurRadius: 20,
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
    audio = ref.read(bLAudioStateProvider.notifier);
    blui = ref.read(bLUIProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the width after the first frame is rendered
      final RenderBox renderBox = containerKey.currentContext?.findRenderObject() as RenderBox;
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
