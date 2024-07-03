import 'package:block_logic/components/loading.dart';
import 'package:block_logic/logic/audio.dart';
import 'package:block_logic/logic/custom_widgets.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLProfilePic extends ConsumerStatefulWidget {
  const BLProfilePic({super.key, this.size = 50, this.onPressed});
  final double size;
  final VoidCallback? onPressed;

  @override
  ConsumerState<BLProfilePic> createState() => _BLProfilePicState();
}

class _BLProfilePicState extends ConsumerState<BLProfilePic> {
  double _opacity = 0;
  bool _isTapped = false;

  void onTapUp(TapUpDetails tapUp) {
    setState(() {
      _isTapped = false;
      _opacity = 0;
    });
    widget.onPressed?.call();
  }

  void onTapDown(TapDownDetails tapDown) {
    setState(() {
      _isTapped = true;
      _opacity = 1;
    });
    BLAudio.playBtn();
  }

  void onTapCancel() {
    setState(() {
      _isTapped = false;
      _opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountProvider);
    final userDetails = ref.watch(userDetailsProvider);
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[300],
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              child: Center(
                child: FractionallySizedBox(
                    widthFactor: 0.8,
                    heightFactor: 0.8,
                    child: user.when(
                        data: (user) {
                          return user == null
                              ? const Icon(FontAwesomeIcons.user)
                              : userDetails.when(data: (userDetails) {
                                  if (userDetails == null) {
                                    return const BLLoading();
                                  }
                                  return Image.network(userDetails.profilePic);
                                }, error: (error, stackTrace) {
                                  debugPrint('testing profile pic');
                                  return const BLLoading();
                                }, loading: () {
                                  debugPrint('loading');
                                  return const BLLoading();
                                });
                        },
                        error: (error, stackTrace) => blankWidget,
                        loading: () => blankWidget)),
              ),
            ),
          ),
          AnimatedOpacity(
              duration: Durations.short3,
              curve: Curves.easeInOut,
              opacity: _opacity,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100), borderRadius: const BorderRadius.all(Radius.circular(100))),
              )),
        ],
      ),
    );
  }
}
