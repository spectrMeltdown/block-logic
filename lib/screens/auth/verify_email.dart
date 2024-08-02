import 'dart:async';

import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text_button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/animation_player.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({super.key});

  @override
  ConsumerState<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends ConsumerState<VerifyEmail>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Timer timer;
  late final AuthService auth;
  late final Toast toast;
  late final CustomNavigation nav;
  late final Assets assets;
  bool processing = false;
  bool isEmailVerified = false;
  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    toast = ref.read(toastProvider);
    nav = ref.read(customNavigationProvider);
    assets = ref.read(assetsProvider);
    _controller = AnimationController(vsync: this);
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!context.mounted) return;
      try {
        await auth.reload();
        isEmailVerified = auth.isEmailVerified();
      } catch (e) {
        return;
      }
      if (isEmailVerified) {
        timer.cancel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          toast.showToast('Email verified successfully');
          nav.pushReplace(context, const MainMenuScreen());
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  // void emailVerified() async {
  //   if (processed) return;
  //   timer.cancel();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (processed) return;
  //     processed = true;
  //     if (context.mounted) {
  //       nav.push(context, const MainMenuScreen());
  //     }
  //     showToast("Email verified successfully");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (isEmailVerified == true) {
    //   emailVerified();
    // }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BLSmallTitle('Please verify your email'),
            const SizedBox(height: 30),
            BLAnimationPlayer(
              assets.emailVerification,
              size: 150,
              controller: _controller,
              controllerActions: (emailAnimation) {
                _controller.duration = emailAnimation.duration;
                _controller.repeat(min: 0, max: 0.65);
              },
            ),
            const SizedBox(height: 30),
            BLTextSpan(
              [
                const TextSpan(text: 'A link was sent to your email:\n'),
                TextSpan(
                    text: auth.getEmail(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const TextSpan(
                    text:
                        "\n\n Just click on the link in that email to complete your signup. \n\n It you don't see it, you may need to check your spam folder.")
              ],
              alignment: TextAlign.center,
            ),
            const SizedBox(height: 70),
            const BLText('Email not received?'),
            const SizedBox(height: 15),
            BLButton(
                onPressed: () {
                  auth.sendEmailVerification();
                },
                child: const BLText('Resend verification email',
                    color: Colors.white)),
            const SizedBox(height: 10),
            BLTextButton(
                onPressed: () => auth.logout(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 10),
                    BLText(
                      'Logout instead',
                      color: Colors.red,
                    )
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
