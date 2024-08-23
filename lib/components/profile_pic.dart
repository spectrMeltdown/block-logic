import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_admin.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLProfilePic extends ConsumerStatefulWidget {
  final String id;
  final double size;
  final VoidCallback? onPressed;
  final AccountType type;
  const BLProfilePic(
    this.id, {
    required this.type,
    super.key,
    this.size = 50,
    this.onPressed,
  });

  @override
  ConsumerState<BLProfilePic> createState() => _BLProfilePicState();
}

class _BLProfilePicState extends ConsumerState<BLProfilePic> {
  double _opacity = 0;
  BLAudioState? audio;

  @override
  Widget build(BuildContext context) {
    final account = widget.type == AccountType.admin
        ? ref.watch(SelectedAdminProvider(widget.id))
        : ref.watch(SelectedUserProvider(widget.id));
    return GestureDetector(
      onTapDown: (TapDownDetails tapDown) {
        audio?.playBtn();
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
                    child: account.when(
                        data: (account) {
                          if (account?.profilePicLink == null ||
                              account!.profilePicLink!.isEmpty) {
                            return const BLLoading(color: Colors.black);
                          } else if (account.profilePicLink == 'default') {
                            return const Icon(FontAwesomeIcons.user);
                          } else {
                            return BLCircular(url: account.profilePicLink);
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

  @override
  void initState() {
    if (!kIsWeb) audio = ref.read(bLAudioStateProvider.notifier);
    super.initState();
  }

  void onTapCancel() {
    if (!kIsWeb) {
      setState(() {
        _opacity = 0;
      });
    }
  }

  void onTapDown() {
    if (!kIsWeb) {
      setState(() {
        _opacity = 1;
      });
    }
  }

  void onTapUp(TapUpDetails tapUp) {
    if (!kIsWeb) {
      setState(() {
        _opacity = 0;
      });
      widget.onPressed?.call();
    }
  }
}
