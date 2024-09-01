import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class Background extends ConsumerStatefulWidget {
  final Widget child;
  final VideoPlayerController? controller;
  final bool grid;
  final String? asset;
  final StackFit fit;
  const Background({
    required this.child,
    this.grid = true,
    this.fit = StackFit.loose,
    this.controller,
    this.asset,
    super.key,
  });

  @override
  ConsumerState<Background> createState() => _BackgroundState();
}

class _BackgroundState extends ConsumerState<Background> {
  late final VideoPlayerController? controller;
  late final Assets assets;

  // late final VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    final blui = ref.read(bLUIProvider.notifier);
    return Stack(
      fit: widget.fit,
      children: [
        // (asset != null)
        //     ? BLAnimationPlayer(
        //         asset!,
        //         size: double.maxFinite,
        //       )
        (widget.asset != null)
            ? widget.controller != null && widget.controller!.value.isInitialized
                ? VideoPlayer(controller!)
                : const BlankWidget()
            : Container(
                decoration: !kIsWeb
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: (widget.grid == true
                                ? AssetImage(assets.backgroundGrid)
                                : AssetImage(assets.backgroundNoGrid)),
                            fit: BoxFit.cover),
                      )
                    : BoxDecoration(
                        gradient: RadialGradient(colors: [
                          blui.getAppColor('darkblue'),
                          Colors.black87,
                        ], radius: 1.5),
                      )),
        Padding(
            padding: kIsWeb ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: widget.child)
      ],
    );
  }

  @override
  void initState() {
    assets = ref.read(assetsProvider);
    controller = widget.controller;
    super.initState();
  }
}
