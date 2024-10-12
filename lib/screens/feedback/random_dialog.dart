import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/animation_player.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/screens/feedback/feedback_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RandomDialog extends ConsumerStatefulWidget {
  final int? count;
  const RandomDialog({this.count, super.key});

  @override
  ConsumerState<RandomDialog> createState() => _RandomDialogState();
}

class _RandomDialogState extends ConsumerState<RandomDialog> with SingleTickerProviderStateMixin {
  late final Assets assets;
  late final CustomNavigation nav;
  late final AnimationController likeAnimation;
  late final SharedPreferences sharedPref;
  @override
  void initState() {
    sharedPref = ref.read(sharedPrefProvider);
    assets = ref.read(assetsProvider);
    nav = ref.read(customNavigationProvider.notifier);
    likeAnimation = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    likeAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
      insetPadding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BLAnimationPlayer(
                assets.like,
                size: 70,
                controller: likeAnimation,
                controllerActions: (premiumCrown) {
                  likeAnimation.duration = premiumCrown.duration;
                  likeAnimation.repeat(min: 0, max: 1);
                },
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BLSmallTitle('Liked our app?'),
                  SizedBox(
                    height: 5,
                  ),
                  BLText('We\'d LOVE you hear from you!'),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BLTextButton(
                  onPressed: () {
                    nav.pop(context);
                  },
                  child: const BLText(
                    'Later',
                    color: Colors.deepOrange,
                  )),
              const SizedBox(
                width: 15,
              ),
              BLTextButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => const FeedbackDialog(),
                    );
                    if (!context.mounted) return;
                    nav.pop(context);
                  },
                  child: const BLText(
                    'Send Feedback',
                    color: Colors.green,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
