import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TopThreePlayers extends ConsumerStatefulWidget {
  final List<String> playerPhotoURL;
  const TopThreePlayers(this.playerPhotoURL, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopThreePlayersState();
}

class _TopThreePlayersState extends ConsumerState<TopThreePlayers> {
  final picStartDelay = const Duration(milliseconds: 500);
  final picDelay = const Duration(milliseconds: 300);
  late final Duration iconStartDelay;
  late final Duration iconDelay;
  late final Assets assets;
  @override
  Widget build(BuildContext context) {
    if (widget.playerPhotoURL.isEmpty) {
      return const Center(
        child: BLText('No players..'),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.playerPhotoURL.length, (i) {
        if (i == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: WidgetAnimator(
                      incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(delay: picStartDelay),
                      child: widget.playerPhotoURL[i].isEmpty || widget.playerPhotoURL[i] == 'default'
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
                              url: widget.playerPhotoURL[i],
                              iconSize: 100,
                            ),
                    ),
                  ),
                  Positioned(
                      left: 17,
                      bottom: -40,
                      child: WidgetAnimator(
                        incomingEffect: WidgetTransitionEffects.incomingOffsetThenScale(delay: picStartDelay),
                        child: Image.asset(
                          assets.leadeboardFirst,
                          width: 60,
                          height: 60,
                          fit: BoxFit.scaleDown,
                        ),
                      ))
                ],
              ),
            ),
          );
        } else if (i == 0 || i == 2) {
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: WidgetAnimator(
                    incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(delay: i == 0 ? picStartDelay + picDelay : picStartDelay + picDelay + picDelay),
                    child: widget.playerPhotoURL[i].isEmpty || widget.playerPhotoURL[i] == 'default'
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
                            url: widget.playerPhotoURL[i],
                            iconSize: 60,
                          ),
                  ),
                ),
                Positioned(
                    bottom: -30,
                    left: i == 0 ? -20 : 30,
                    child: WidgetAnimator(
                      incomingEffect: WidgetTransitionEffects.incomingOffsetThenScale(delay: i == 0 ? iconStartDelay + iconDelay : iconStartDelay + iconDelay + iconDelay),
                      child: Image.asset(
                        i == 0 ? assets.leadeboardSecond : assets.leadeboardThird,
                        width: 50,
                        height: 50,
                        fit: BoxFit.scaleDown,
                      ),
                      // BLCircular(
                      //   width: 50,
                      //   height: 50,
                      //   fit: BoxFit.scaleDown,
                      //   asset:
                      //   backgroundColor: Colors.transparent,
                      // ),
                    ))
              ],
            ),
          );
        }
        debugPrint('Received an extra $i top player.');
        return const BlankWidget();
      }),
    );
  }

  @override
  void initState() {
    iconStartDelay = picStartDelay + picDelay + picDelay;
    iconDelay = picDelay;
    assets = ref.read(assetsProvider);
    super.initState();
  }
}
