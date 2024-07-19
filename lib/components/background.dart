import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class Background extends ConsumerStatefulWidget {
  const Background({
    required this.child,
    this.grid = true,
    this.controller,
    this.asset,
    super.key,
  });
  final Widget child;
  final VideoPlayerController? controller;
  final bool grid;
  final String? asset;

  @override
  ConsumerState<Background> createState() => _BackgroundState();
}

class _BackgroundState extends ConsumerState<Background> {
  late final VideoPlayerController? controller;
  late final Assets assets;

  @override
  void initState() {
    assets = ref.read(assetsProvider);
    controller = widget.controller ?? VideoPlayerController.asset(assets.bg1);
    super.initState();
  }

  // late final VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // (asset != null)
        //     ? BLAnimationPlayer(
        //         asset!,
        //         size: double.maxFinite,
        //       )
        (widget.asset != null)
            ? widget.controller != null &&
                    widget.controller!.value.isInitialized
                ? VideoPlayer(controller!)
                : const BlankWidget()
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: (widget.grid == true
                          ? AssetImage(assets.backgroundGrid)
                          : AssetImage(assets.backgroundNoGrid)),
                      fit: BoxFit.cover),
                ),
              ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: widget.child)
      ],
    );
  }
}
