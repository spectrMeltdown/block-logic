import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLCard extends ConsumerStatefulWidget {
  const BLCard({
    super.key,
    this.type,
    required this.onPressed,
    required this.child,
    this.height = 80,
    this.padding,
    this.color,
  });
  final CodeBlockType? type;
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets? padding;
  final double height;
  final Color? color;

  @override
  ConsumerState<BLCard> createState() => _BLCardState();
}

class _BLCardState extends ConsumerState<BLCard> {
  bool _isTapped = false;
  late final List<Color> cardColorPressed;
  late final List<Color> cardColor;
  final Color darkerShade = Colors.blueGrey.shade900;
  final Color darkShade = Colors.blueGrey.shade800;
  final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 20,
    ),
  ];
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

  @override
  void initState() {
    cardColor = [BLUI().getBlockColor(widget.type), darkShade];
    cardColorPressed = [
      BLUI().getBlockColor(widget.type).brighten(0.2),
      darkShade
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audio = ref.read(bLAudioStateProvider.notifier);
    final mediaQuery = ref.watch(bLMediaQueryProvider);

    /// space around the card
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:

          /// detect user touches
          GestureDetector(
        onTapDown: (details) {
          audio.playBtn;
          _onTapDown();
        },
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,

        /// when user touches card, but releases it outside the card
        child:

            /// the actual card
            SizedBox(
                width: mediaQuery.screenW(context),
                height: widget.height,
                child: Container(
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.white, width: 3.0),
                    gradient: RadialGradient(
                        colors: _isTapped ? cardColorPressed : cardColor,
                        radius: (widget.padding != null)
                            ? getRadius(widget.padding)
                            : 5),
                    boxShadow: (_isTapped
                        ? cardShadow
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              spreadRadius: -20,
                              blurRadius: 10,
                            )
                          ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [widget.child]),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                )),
      ),
    );
  }
}
