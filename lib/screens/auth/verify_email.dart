import 'dart:async';

import 'package:block_logic/components/animation_player.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/logic/assets.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/toast.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({super.key});

  @override
  ConsumerState<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends ConsumerState<VerifyEmail> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Timer timer;
  bool isEmailVerified = false;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    timer = Timer.periodic(const Duration(seconds: 5), (_) => checkEmailVerified());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkEmailVerified() async {
    try {
      await AuthService.reload();
      setState(() {
        isEmailVerified = AuthService.isEmailVerified();
      });
    } catch (e) {
      return;
    }

    if (isEmailVerified == true) {
      timer.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Utils.push(context, const MainMenuScreen());
        showToast("Email verified successfully");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountProvider);

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
              Assets.emailVerification,
              size: 150,
              controller: _controller,
              controllerActions: (emailAnimation) {
                _controller.duration = emailAnimation.duration;
                _controller.repeat(min: 0, max: 0.65);
              },
            ),
            const SizedBox(height: 30),
            user.when(
                data: (user) {
                  return BLTextSpan(
                    [
                      const TextSpan(text: "A link was sent to your email:\n"),
                      TextSpan(
                          text: user?.email ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const TextSpan(
                          text:
                              "\n\n Just click on the link in that email to complete your signup. \n\n It you don't see it, you may need to check your spam folder.")
                    ],
                    alignment: TextAlign.center,
                  );
                },
                error: (error, stackTrace) => blankWidget,
                loading: () => blankWidget),
            const SizedBox(height: 70),
            const BLText("Email not received?"),
            const SizedBox(height: 15),
            BLButton(
                onPressed: () {
                  AuthService.sendEmailVerification(context);
                },
                child: const BLText('Resend verification email', color: Colors.white)),
            const SizedBox(height: 10),
            BLTextButton(
                onPressed: () => AuthService.logout(context),
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
