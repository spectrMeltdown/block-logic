import 'dart:async';

import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPhoneNum extends ConsumerStatefulWidget {
  final String phoneNum;
  const VerifyPhoneNum(this.phoneNum, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyPhoneNumState();
}

class _VerifyPhoneNumState extends ConsumerState<VerifyPhoneNum> {
  // late final SmsService sms;
  // late final OtpService otpService;
  late final Toast toast;
  late final TextValidator validator;
  late final AccountService accountService;
  late Timer timer;
  int seconds = 30;
  final formKey = GlobalKey<FormState>();
  bool processing = false;
  String verificationID = '';
  String resendToken = '';
  // String otp = '';
  bool initSent = false;
  final otpInput = TextEditingController();
  late AsyncValue<User?> account;
  late final AuthService auth;
  late final CustomNavigation nav;
  late final SharedPreferences sharedPref;
  @override
  Widget build(BuildContext context) {
    account = ref.watch(authChangesProvider);
    final media = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: media.size.height - media.padding.top),
                  child: account.when(
                      data: (account) {
                        if (account == null) {
                          return const Center(
                            child: BLText(
                              'You need be logged in to perform this action.',
                            ),
                          );
                        }
                        if (!kDebugMode) {
                          if (initSent == false) {
                            sendOTP();
                            initSent = true;
                          }
                        }
                        return Padding(
                          padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Form(
                              key: formKey,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const BLSmallTitle('Verify phone number'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: BLText(
                                        'We need to verify the phone number ${widget.phoneNum}.\n',
                                        alignCenter: true,
                                        softWrap: true,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: BLTextBox(
                                        controller: otpInput,
                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                        onFieldSubmitted: (p0) => verifyOTP(account),
                                        prefixIcon: const Icon(Icons.numbers),
                                        labelText: '6-digit code',
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        validator: (otp) => validator.validateOtp(otp),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    BLTextButton(
                                        onPressed: () => sendOTP(),
                                        child: BLText(
                                          timer.isActive ? 'Send OTP ($seconds)' : 'Send OTP',
                                          color: timer.isActive ? Colors.grey : null,
                                        )),
                                    BLButton(
                                        onPressed: () => verifyOTP(account),
                                        child: const BLText(
                                          'Verify',
                                          size: 18,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    BLTextButton(
                                        onPressed: () {
                                          // nav.pushReplace(context, const MainMenuScreen());
                                          nav.pop(context);
                                        },
                                        child: const BLText(
                                          'Cancel',
                                          color: Colors.deepOrange,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      error: genericError,
                      loading: genericLoading),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    accountService = ref.read(accountServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    sharedPref = ref.read(sharedPrefProvider);
    // sms = ref.read(smsServiceProvider.notifier);
    // otpService = ref.read(otpServiceProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    timer = Timer(Duration.zero, () {});
    timer.cancel();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void updateCallBack({
    required String resendToken,
    required String verificationID,
  }) async {
    this.resendToken = resendToken;
    this.verificationID = verificationID;
  }

  void sendOTP() async {
    if (processing || timer.isActive) return;
    processing = true;

    final result = await accountService.verifyPhoneNumber(
      context: context,
      phoneNumber: widget.phoneNum,
      resendToken: resendToken,
      type: AccountType.user,
      updateCallBack: updateCallBack,
    );
    if (result != null) {
      if (!mounted) return;
      toast.showToast(context, result, type: NotifType.error);
    } else {
      // if(!context.mounted) return; toast.showToast(context,'OTP sent!', type: NotifType.success);
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

  Timer createTimer() {
    return Timer.periodic(const Duration(seconds: 1), (time) {
      if (seconds != 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          seconds = 30;
        });
        timer.cancel();
      }
    });
  }

  void verifyOTP(User? account) async {
    if (processing) return;
    processing = true;

    if (formKey.currentState!.validate()) {
      // link it
      final result = await accountService.continuePhoneNumVerify(verificationID, otpInput.text.trim());
      if (result == null) {
        if (!mounted) return;
        toast.showToast(context, 'Phone verified successfully.', type: NotifType.success);
        if (kIsWeb) {
          if (!mounted) return;
          context.go('/dashboard');
        } else {
          if (!mounted) return;
          // nav.pushAndRemove(context, const Checkpoint());
          nav.pop(context);
        }
      } else {
        if (!mounted) return;
        toast.showToast(context, result, type: NotifType.error);
      }
    }
    processing = false;
  }

  /// Cancelling this because firebase auth provides otp, just on a limit
  // void send() async {
  //   final result = await sms.send(phoneNum, otp.getOTP().toString());
  //   if (result == null) {
  //     if(!context.mounted) return; toast.showToast(context,'OTP sent!', type: NotifType.success);
  //   } else {
  //     if(!context.mounted) return; toast.showToast(context,result, type: NotifType.error);
  //   }
  // }
}
