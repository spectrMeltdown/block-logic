import 'package:block_logic/components/animation_player.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class Background extends StatelessWidget {
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
        (asset != null)
            ? controller != null && controller!.value.isInitialized
                ? VideoPlayer(controller!)
                : blankWidget
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: (grid == true
                          ? const AssetImage(Assets.backgroundGrid)
                          : const AssetImage(Assets.backgroundNoGrid)),
                      fit: BoxFit.cover),
                ),
              ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15), child: child)
      ],
    );
  }
}
