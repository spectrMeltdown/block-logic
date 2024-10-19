import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/animation_player.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLLoading extends ConsumerStatefulWidget {
  final Color? color;

  /// Size overrides height & width
  final double? size;
  final String? message;
  final double? height;
  final double? width;
  final LoadingType type;
  const BLLoading({
    super.key,
    this.message,
    this.type = LoadingType.fill,
    this.height = 200,
    this.width = 200,
    this.color,
    this.size,
  });

  @override
  ConsumerState<BLLoading> createState() => _BLLoadingState();
}

class _BLLoadingState extends ConsumerState<BLLoading> with TickerProviderStateMixin {
  AnimationController? _controller;
  late final Assets assets;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _controller = AnimationController(vsync: this);
    assets = ref.read(assetsProvider);
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case LoadingType.fill:
        return FadeIn(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.message != null) BLText(widget.message!),
                if (widget.message != null) const SizedBox(height: 10),
                BLAnimationPlayer(
                  assets.loadingBricks1,
                  size: 100,
                )
              ],
            ),
          ),
        );
      case LoadingType.tight:
        return FadeIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.message != null) BLText(widget.message!),
              if (widget.message != null) const SizedBox(height: 10),
              BLAnimationPlayer(
                assets.loadingBricks1,
                size: 100,
              )
            ],
          ),
        );
    }
  }
}
