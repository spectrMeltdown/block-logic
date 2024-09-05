import 'dart:async';

import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_model.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyPhoneNum extends ConsumerStatefulWidget {
  const VerifyPhoneNum({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyPhoneNumState();
}

class _VerifyPhoneNumState extends ConsumerState<VerifyPhoneNum> {
  // late final SmsService sms;
  // late final OtpService otpService;
  late final Toast toast;
  late final TextValidator validator;
  late final AccountService accountService;
  Timer? timer;
  int seconds = 30;
  bool displayDelay = false;
  final formKey = GlobalKey<FormState>();
  bool processing = false;
  String phoneNum = '';
  int? resendToken;
  // String otp = '';
  bool initSent = false;
  String verificationID = '';
  final otpInput = TextEditingController();
  late AsyncValue<UserAccount?> account;
  late final AuthService auth;
  late final CustomNavigation nav;
  @override
  Widget build(BuildContext context) {
    account = ref.watch(SelectedUserProvider(auth.getUID()));
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
                        phoneNum = account.phoneNum != null ? '+63${account.phoneNum}' : '--';
                        resendToken = account.resendToken;
                        if (!kDebugMode) {
                          if (initSent == false) {
                            sendOTP();
                            initSent = true;
                          }
                        }
                        verificationID = account.verificationID ?? '';
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
                                        'We need to verify the phone number $phoneNum.\n',
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
                                        onFieldSubmitted: (p0) => verifyOTP(context, account),
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
                                          displayDelay ? 'Send OTP ($seconds)' : 'Send OTP',
                                          color: displayDelay ? Colors.grey : null,
                                        )),
                                    BLButton(
                                        onPressed: () => verifyOTP(context, account),
                                        child: const BLText(
                                          'Submit',
                                          size: 18,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    BLTextButton(
                                        onPressed: () {
                                          nav.pushReplace(context, const MainMenuScreen());
                                        },
                                        child: const BLText(
                                          'I\'ll do this later.',
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
    nav = ref.read(customNavigationProvider);
    accountService = ref.read(accountServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    // sms = ref.read(smsServiceProvider.notifier);
    // otpService = ref.read(otpServiceProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void sendOTP() async {
    if (processing || displayDelay) return;
    processing = true;

    final result =
        await accountService.verifyPhoneNumber(phoneNum, kIsWeb ? AccountType.admin : AccountType.user, resendToken);
    if (result != null) {
      toast.showToast(result, type: NotifType.error);
    } else {
      toast.showToast('OTP sent!', type: NotifType.success);
      setState(() {
        displayDelay = true;
        timer = Timer.periodic(const Duration(seconds: 1), (time) {
          if (seconds != 0) {
            setState(() {
              seconds--;
            });
          } else {
            setState(() {
              seconds = 30;
              displayDelay = false;
            });
            timer!.cancel();
          }
        });
      });
    }
    // otp = otpService.getOTP().toString();
    // final result = await sms.send(phoneNum, otp!);

    processing = false;
  }

  void verifyOTP(BuildContext context, AccountModel account) async {
    if (processing) return;
    processing = true;

    if (formKey.currentState!.validate()) {
      final result = await accountService.continuePhoneNumVerify(verificationID, otpInput.text.trim());
      if (result == null) {
        toast.showToast('Phone verified successfully.', type: NotifType.success);
        if (kIsWeb) {
          if (!context.mounted) return;
          context.go('/dashboard');
        } else {
          if (!context.mounted) return;
          nav.pushAndRemove(context, const Checkpoint());
        }
      } else {
        toast.showToast(result, type: NotifType.error);
      }
    }
    processing = false;
  }

  /// Cancelling this because firebase auth provides otp, just on a limit
  // void send() async {
  //   final result = await sms.send(phoneNum, otp.getOTP().toString());
  //   if (result == null) {
  //     toast.showToast('OTP sent!', type: NotifType.success);
  //   } else {
  //     toast.showToast(result, type: NotifType.error);
  //   }
  // }
}
