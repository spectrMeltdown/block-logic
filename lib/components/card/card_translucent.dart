import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/color.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLTranslucentCard extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final String? icon;
  final String title;
  final String subTitle;
  final Widget? bottomRowStart;
  final Widget? bottomRowEnd;
  final EdgeInsets? padding;
  final double? height;
  final Color? color;
  final bool? hasPass;
  const BLTranslucentCard({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.height,
    this.padding,
    this.color,
    this.hasPass,
    this.icon,
    required this.title,
    this.subTitle = '',
    this.bottomRowStart,
    this.bottomRowEnd,
  });

  @override
  ConsumerState<BLTranslucentCard> createState() => _BLCardState();
}

class _BLCardState extends ConsumerState<BLTranslucentCard> {
  bool _isTapped = false;
  late final List<Color> cardColorPressed;
  late final List<Color> cardColor;
  final Color darkShade = Colors.blueGrey.shade800;
  final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final audio = ref.read(bLAudioStateProvider.notifier);
    final mediaQuery = MediaQuery.of(context);

    /// space around the card
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child:

          /// detect user touches
          GestureDetector(
        onTapDown: (details) {
          audio.playBtn;
          _onTapDown();
        },
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onLongPress: widget.onLongPress,

        /// when user touches card, but releases it outside the card
        child:

            /// the actual card
            SizedBox(
                width: mediaQuery.size.width,
                height: widget.height,
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.white, width: 3.0),
                    gradient: RadialGradient(colors: _isTapped ? cardColorPressed : cardColor, radius: (widget.padding != null) ? getRadius(widget.padding) : 5),
                    boxShadow: (_isTapped ? cardShadow : null),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BLText(
                                widget.title,
                                color: BLUI().getAppColor('amber'),
                                bold: true,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              widget.hasPass == null
                                  ? const BlankWidget()
                                  : widget.hasPass ?? false
                                      ? const Icon(Icons.lock_outline_rounded)
                                      : const BlankWidget()
                            ],
                          ),
                          if (widget.subTitle.isNotEmpty)
                            Row(
                              children: [
                                BLText(
                                  widget.subTitle,
                                  color: BLUI().getAppColor(''),
                                  size: 16,
                                )
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [widget.bottomRowStart ?? const BlankWidget(), widget.bottomRowEnd ?? const BlankWidget()],
                          )
                        ]),
                      ),
                    ],
                  ),
                )),
      ),
    );
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
    cardColor = [Colors.grey.withOpacity(0.5), darkShade];
    cardColorPressed = [Colors.grey.brighten(0.2), darkShade];
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
