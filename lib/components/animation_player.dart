import 'package:flame_lottie/flame_lottie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BLAnimationPlayer extends StatefulWidget {
  const BLAnimationPlayer(this.animation,
      {this.controller, this.controllerActions, this.height = 200, this.width = 200, this.size, super.key});
  final String animation;
  final AnimationController? controller;
  final void Function(LottieComposition)? controllerActions;

  /// Size overrides height & width
  final double? size;
  final double? height;
  final double? width;

  @override
  State<BLAnimationPlayer> createState() => _BLAnimationPlayerState();
}

class _BLAnimationPlayerState extends State<BLAnimationPlayer> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.animation,
      controller: widget.controller,
      renderCache: RenderCache.drawingCommands,
      width: (widget.size != null) ? widget.size : widget.width,
      height: (widget.size != null) ? widget.size : widget.height,
      onLoaded: (comp) {
        if (kDebugMode) {
          for (int i = 0; i <= comp.layers.length; i++) {
            debugPrint('Found $i layers');
          }
        }
        widget.controllerActions?.call(comp);
      },
    );
  }
}
