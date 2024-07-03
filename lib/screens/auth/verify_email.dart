import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmail extends ConsumerWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const SizedBox(
              height: 30,
            ),
            user.when(
                data: (user) {
                  return BLText(
                    "A verification was sent to your email \n${user?.email ?? ''} \n\n Just click on the link in that email to complete your signup. \n\n It you don't see it, you may need to check your spam folder.",
                    alignCenter: true,
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
