import 'package:block_logic/game/assets.dart';
import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  const Background({
    required this.child,
    this.grid = true,
    super.key,
  });
  final Widget child;
  final bool grid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
