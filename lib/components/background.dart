import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Background extends ConsumerWidget {
  final Widget child;
  // final VideoPlayerController? controller;
  final bool grid;
  final String? asset;
  final StackFit fit;
  const Background({
    required this.child,
    this.grid = true,
    this.fit = StackFit.loose,
    // this.controller,
    this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final assets = ref.read(assetsProvider);
    final blui = ref.read(bLUIProvider.notifier);
    return Stack(
      fit: fit,
      children: [
        // (asset != null)
        //     ? controller != null && controller!.value.isInitialized
        //         ? //VideoPlayer(controller!)
        //         : const BlankWidget()
        //     :

        Container(
            decoration: !kIsWeb
                ? BoxDecoration(
                    image: DecorationImage(
                      image: (grid == true ? AssetImage(assets.backgroundGrid) : AssetImage(assets.backgroundNoGrid)),
                      fit: BoxFit.cover,
                    ),
                  )
                : BoxDecoration(
                    gradient: RadialGradient(colors: [
                      blui.getAppColor('darkblue'),
                      Colors.black87,
                    ], radius: 1.5),
                  )),
        Padding(padding: kIsWeb ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 5, vertical: 0), child: child)
      ],
    );
  }
}
