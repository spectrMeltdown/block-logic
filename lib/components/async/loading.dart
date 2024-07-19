import 'package:block_logic/components/util/animation_player.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLLoading extends ConsumerStatefulWidget {
  const BLLoading(
      {super.key,
      this.type = LoadingType.normal,
      this.height = 200,
      this.width = 200,
      this.color,
      this.size});

  final Color? color;

  /// Whether to be full screen or not
  final LoadingType type;

  /// Size overrides height & width
  final double? size;
  final double? height;
  final double? width;

  @override
  ConsumerState<BLLoading> createState() => _BLLoadingState();
}

class _BLLoadingState extends ConsumerState<BLLoading>
    with TickerProviderStateMixin {
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
    final assets = ref.watch(assetsProvider);
    switch (widget.type) {
      case LoadingType.full:
        return Center(
            child: BLAnimationPlayer(
          assets.loading,
          controller: _controller,
          size: 200,
        ));
      case LoadingType.normal:
        return Center(
            child: CircularProgressIndicator(
          color: widget.color ?? Colors.white,
        ));
      default:
        return const BlankWidget();
    }
  }
}
