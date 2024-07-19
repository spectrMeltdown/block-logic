import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/util/blank_widget.dart';

import 'package:block_logic/logic/firebase_providers/user.dart';
import 'package:block_logic/logic/services/audio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLProfilePic extends ConsumerStatefulWidget {
  const BLProfilePic(this.accountID,
      {super.key, this.size = 50, this.onPressed});
  final String accountID;
  final double size;
  final VoidCallback? onPressed;

  @override
  ConsumerState<BLProfilePic> createState() => _BLProfilePicState();
}

class _BLProfilePicState extends ConsumerState<BLProfilePic> {
  double _opacity = 0;
  String? oldPhotoURL;

  void onTapUp(TapUpDetails tapUp) {
    setState(() {
      _opacity = 0;
    });
    widget.onPressed?.call();
  }

  void onTapDown() {
    setState(() {
      _opacity = 1;
    });
  }

  void onTapCancel() {
    setState(() {
      _opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoURL = ref.watch(UserProfilePicProvider(widget.accountID));
    final audio = ref.read(bLAudioProvider.notifier);
    return GestureDetector(
      onTapDown: (TapDownDetails tapDown) {
        audio.playBtn();
        onTapDown();
      },
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Stack(
        children: [
          /// profile pic border
          Container(
            width: widget.size,
            height: widget.size,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[300],
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),

            /// profile pic
            child: CircleAvatar(
              child: Center(
                child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: photoURL.when(
                        data: (photoURL) {
                          debugPrint('update profile pic widget');
                          if (photoURL == null || photoURL.isEmpty) {
                            return const BLLoading(color: Colors.black);
                          } else if (photoURL == 'new_user') {
                            return const Icon(FontAwesomeIcons.user);
                          } else {
                            return BLCircularImage(photoURL);
                          }
                        },
                        error: (error, stackTrace) => const BlankWidget(),
                        loading: () => const BlankWidget())),
              ),
            ),
          ),

          /// blank overlay when tapDown
          AnimatedOpacity(
              duration: Durations.short3,
              curve: Curves.easeInOut,
              opacity: _opacity,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: const BorderRadius.all(Radius.circular(100))),
              )),
        ],
      ),
    );
  }
}
