import 'package:block_logic/components/circular_image.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_model.dart';
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
  final bool withBg;
  const BLProfilePic(
    this.id, {
    required this.type,
    this.withBg = true,
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
    final account = widget.type == AccountType.admin ? ref.watch(SelectedAdminProvider(widget.id)) : ref.watch(SelectedUserProvider(widget.id));
    return GestureDetector(
        onTapDown: kIsWeb
            ? null
            : (TapDownDetails tapDown) {
                audio?.playBtn();
                onTapDown();
              },
        onTapUp: kIsWeb ? null : onTapUp,
        onTapCancel: kIsWeb ? null : onTapCancel,
        child: widget.withBg
            ? Stack(
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
                      child: profilePic(account)),

                  /// blank overlay when tapDown
                  AnimatedOpacity(
                      duration: Durations.short3,
                      curve: Curves.easeInOut,
                      opacity: _opacity,
                      child: Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(color: Colors.black.withAlpha(100), borderRadius: const BorderRadius.all(Radius.circular(100))),
                      )),
                ],
              )
            : profilePic(account));
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) audio = ref.read(bLAudioStateProvider.notifier);
  }

  void onTapCancel() {
    setState(() {
      _opacity = 0;
    });
  }

  void onTapDown() {
    setState(() {
      _opacity = 1;
    });
  }

  void onTapUp(TapUpDetails tapUp) {
    setState(() {
      _opacity = 0;
    });
    widget.onPressed?.call();
  }

  Widget profilePic(AsyncValue<AccountModel?> account) {
    return account.when(
        data: (account) {
          // dPrint('Profile pic link: ${account?.profilePicLink}');
          if (account?.profilePicLink == null || account!.profilePicLink!.isEmpty || account.profilePicLink!.contains('default')) {
            return const FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                ),
              ),
            );
          }
          return BLCircular(url: account.profilePicLink);
        },
        error: blankError,
        loading: blankLoading);
  }
}
