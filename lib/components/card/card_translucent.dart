import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLTranslucentCard extends ConsumerStatefulWidget {
  const BLTranslucentCard({
    super.key,
    required this.onPressed,
    this.height,
    this.padding,
    this.color,
    required this.icon,
    required this.title,
    this.subTitle = '',
    this.bottomRowStart,
    this.bottomRowEnd,
  });
  final VoidCallback onPressed;
  final String icon;
  final String title;
  final String subTitle;
  final Widget? bottomRowStart;
  final Widget? bottomRowEnd;
  final EdgeInsets? padding;
  final double? height;
  final Color? color;

  @override
  ConsumerState<BLTranslucentCard> createState() => _BLCardState();
}

class _BLCardState extends ConsumerState<BLTranslucentCard> {
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
    cardColor = [Colors.white.withOpacity(0.5), darkShade];
    cardColorPressed = [Colors.white.brighten(0.2), darkShade];
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
                    children: [
                      BLCircularImage(
                        widget.icon,
                        background: Colors.black45,
                      ),
                      const SizedBox(width: 30),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BLText(
                                  widget.title,
                                  color: BLUI().getAppColor('darkblue'),
                                  bold: true,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                BLText(
                                  widget.subTitle,
                                  color: BLUI().getAppColor('amber'),
                                  size: 17,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.bottomRowStart ?? const BlankWidget(),
                                widget.bottomRowEnd ?? const BlankWidget()
                              ],
                            )
                          ]),
                    ],
                  ),
                )),
      ),
    );
  }
}
