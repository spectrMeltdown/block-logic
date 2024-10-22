import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/text/text.dart';

import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TopThreePlayers extends ConsumerWidget {
  final List<String> playerPhotoURL;
  const TopThreePlayers(this.playerPhotoURL, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    const picStartDelay = Duration(milliseconds: 500);
    const picDelay = Duration(milliseconds: 300);
    final iconStartDelay = picStartDelay + picDelay + picDelay;
    const iconDelay = picDelay;
    final assets = ref.read(assetsProvider);
    if (playerPhotoURL.isEmpty) {
      return const Center(
        child: BLText('No players..'),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(playerPhotoURL.length, (i) {
        if (i == 0) {
          return TopPlayerItem(
            playerPhotoURL: playerPhotoURL[1],
            picDelay: picStartDelay + picDelay,
            iconStartDelay: iconStartDelay + iconDelay,
            medalIcon: assets.leadeboardSecond,
            leftPos: -20,
          );
        } else if (i == 1) {
          return TopPlayerItem(
            playerPhotoURL: playerPhotoURL[0],
            picDelay: picStartDelay,
            iconStartDelay: iconStartDelay,
            width: 90,
            height: 90,
            medalIcon: assets.leadeboardFirst,
            leftPos: 17,
          );
        } else {
          return TopPlayerItem(
            playerPhotoURL: playerPhotoURL[2],
            picDelay: picStartDelay + picDelay + picDelay,
            iconStartDelay: iconStartDelay + iconDelay + iconDelay,
            medalIcon: assets.leadeboardThird,
            leftPos: 30,
          );
        }
      }),
    );
  }
}

class TopPlayerItem extends ConsumerWidget {
  final Duration picDelay;
  final String playerPhotoURL;
  final Duration iconStartDelay;
  final String medalIcon;
  final double leftPos;
  final double bottom;
  final double? width;
  final double? height;
  const TopPlayerItem({
    required this.picDelay,
    required this.playerPhotoURL,
    required this.iconStartDelay,
    required this.medalIcon,
    required this.leftPos,
    this.width,
    this.height,
    this.bottom = -30,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: width != null ? 0 : 60, bottom: width != null ? 10 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: height ?? 60,
            width: width ?? 60,
            child: WidgetAnimator(
              incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(delay: picDelay),
              child: playerPhotoURL.isEmpty || playerPhotoURL == 'default'
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(FontAwesomeIcons.user),
                        ),
                      ),
                    )
                  : BLCircular(
                      url: playerPhotoURL,
                      iconSize: 60,
                    ),
            ),
          ),
          Positioned(
              bottom: bottom,
              left: leftPos,
              child: WidgetAnimator(
                incomingEffect: WidgetTransitionEffects.incomingOffsetThenScale(delay: iconStartDelay),
                child: Image.asset(
                  medalIcon,
                  width: 50,
                  height: 50,
                  fit: BoxFit.scaleDown,
                ),
              ))
        ],
      ),
    );
  }
}
