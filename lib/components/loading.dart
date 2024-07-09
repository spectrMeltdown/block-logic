import 'package:block_logic/components/animation_player.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:flutter/material.dart';

enum LoadingType { full, normal }

class BLLoading extends StatefulWidget {
  const BLLoading({super.key, this.type = LoadingType.full, this.height = 200, this.width = 200, this.size});

  /// Whether to be full screen or not
  final LoadingType type;

  /// Size overrides height & width
  final double? size;
  final double? height;
  final double? width;

  @override
  State<BLLoading> createState() => _BLLoadingState();
}

class _BLLoadingState extends State<BLLoading> with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case LoadingType.full:
        return Center(
            child: BLAnimationPlayer(
          Assets.loading,
          controller: _controller,
          size: 200,
        ));
      case LoadingType.normal:
        return const CircularProgressIndicator();
      default:
        return blankWidget;
    }
  }
}
