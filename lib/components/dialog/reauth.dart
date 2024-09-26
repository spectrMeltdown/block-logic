import 'dart:async';

import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReauthDialog extends ConsumerStatefulWidget {
  const ReauthDialog({super.key});

  @override
  ConsumerState<ReauthDialog> createState() => _ReauthDialogState();
}

class _ReauthDialogState extends ConsumerState<ReauthDialog> {
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  int attemptsLeft = 3;
  late Widget msg;
  bool processing = false;
  late bool firstOTPSent;
  late final bool useEmail;
  late final CustomNavigation nav;
  late final AuthService auth;
  late final AccountService accountService;
  late final TextValidator validator;
  late Timer timer;
  int secondsLeft = 30;
  String resendToken = '';
  String verificationID = '';
  late final String phoneNum;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    phoneNum = FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    useEmail = phoneNum.isEmpty;
    firstOTPSent = useEmail;
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    accountService = ref.read(accountServiceProvider.notifier);
    msg = const BlankWidget();
    timer = Timer(Duration.zero, () {});
    timer.cancel();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void updateMsg(String? error, {Color color = Colors.red}) {
    setState(() {
      msg = Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: BLText(
          error ?? '',
          color: color,
          alignCenter: true,
        ),
      );
    });
  }

  void toggleProcessing(bool newState) {
    setState(() {
      processing = newState;
    });
  }

  void updateCallBack({
    required String resendToken,
    required String verificationID,
  }) async {
    this.resendToken = resendToken;
    this.verificationID = verificationID;
  }

  Timer createTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 1) {
        setState(() {
          secondsLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          secondsLeft = 30;
        });
      }
    });
  }

  void sendOTP(BuildContext context) async {
    // get from token firebase admin sdk
    // send sms using semaphore
    if (processing || timer.isActive) return;
    processing = true;
    // var result = null;
    final result = await accountService.verifyPhoneNumber(
      context: context,
      phoneNumber: phoneNum,
      resendToken: resendToken,
      type: AccountType.user,
      updateCallBack: updateCallBack,
    );
    if (result != null) {
      updateMsg(result);
    } else {
      // updateMsg('OTP sent!', color: Colors.green);
      if (firstOTPSent == false) {
        setState(() {
          firstOTPSent = true;
        });
      }
      setState(() {
        timer = createTimer();
      });
      // resendToken = sharedPref.getString('resendToken')!;
      // verificationID = sharedPref.getString('verificationID')!;
    }
    // otp = otpService.getOTP().toString();
    // final result = await sms.send(phoneNum, otp!);

    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      title: const BLSmallTitle('Verification'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLText(
              useEmail ? 'Enter your current password' : 'Enter the OTP:',
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            if (useEmail)
              BLTextBox(
                controller: passwordController,
                labelText: 'Your password here',
                isObscure: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (pass) => validator.validatePassword(pass),
              ),
            if (!useEmail)
              BLTextBox(
                controller: otpController,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                prefixIcon: const Icon(Icons.numbers),
                labelText: '6-digit code',
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (otp) => validator.validateOtp(otp),
              ),
            if (!useEmail)
              BLTextButton(
                onPressed: () {
                  if (!timer.isActive) {
                    sendOTP(context);
                  }
                },
                child: BLText(
                  'Send OTP ${timer.isActive ? '($secondsLeft)' : ''}',
                  color: timer.isActive ? Colors.grey : null,
                ),
              ),
            msg,
          ],
        ),
      ),
      actions: [
        BLTextButton(
          onPressed: () {
            nav.pop(context, 'cancelled');
          },
          child: BLText(
            'Cancel',
            color: processing ? Colors.grey : Colors.red,
          ),
        ),
        BLTextButton(
          onPressed: () async {
            if (!firstOTPSent) {
              updateMsg('Send an OTP first.');
              return;
            }
            if (processing) return;
            toggleProcessing(true);
            if (useEmail) {
              final result = await auth.reauth(passwordController.text.trim());
              if (!context.mounted) return;
              if (result == null) {
                nav.pop(context, null);
              } else if (result == 'too-many-attempts') {
                nav.pop(context, 'TOA');
              } else {
                if (attemptsLeft == 1) {
                  nav.pop(context, 'failed');
                } else {
                  attemptsLeft = attemptsLeft - 1;
                  updateMsg('Wrong password. Attempts left: $attemptsLeft');
                }
              }
            } else {
              final result = await auth.loginPhone(
                // phone: phoneNum,
                code: otpController.text.trim(),
                verificationID: verificationID,
              );
              if (result != null) {
                updateMsg(result);
              } else {
                if (!context.mounted) return;
                nav.pop(context, null);
              }
            }
            toggleProcessing(false);
          },
          child: BLText(
            'Submit',
            color: processing || !firstOTPSent ? Colors.grey : Colors.green,
          ),
        ),
      ],
    );
  }
}
