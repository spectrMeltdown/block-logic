import 'dart:async';

import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/login_alert.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/forgot_password.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class Login extends ConsumerStatefulWidget {
  final FirestoreCollections accountType;
  const Login({required this.accountType, super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> with RouteAware {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  late Toast toast;
  late final AuthService auth;
  late final CustomNavigation nav;
  late final TextValidator validator;
  late Timer otpCooldownTimer;
  String verificationID = '';
  bool processing = false;
  bool useEmail = true;
  bool firstOTPSent = false;
  int secondsLeft = 30;

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    final width = mediaQ.size.width;

    return PopScope(
      canPop: processing,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: kIsWeb ? Alignment.center : AlignmentDirectional.topStart,
          fit: StackFit.expand,
          children: [
            Background(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: mediaQ.viewInsets.bottom),
                    height: kIsWeb ? mediaQ.size.height : null,
                    child: Column(
                      mainAxisAlignment: kIsWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
                      children: [
                        if (!kIsWeb) const Align(child: Align(alignment: Alignment.centerLeft, child: BLBackButton())),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: width <= mobileMax
                                    ? kIsWeb
                                        ? 450
                                        : 330
                                    : 600),
                            child: BLPanel(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kIsWeb ? 50 : 20,
                                  vertical: kIsWeb ? 50 : 35,
                                ),
                                child: Form(
                                  key: _loginFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 5),
                                      const BLTitle(
                                        kIsWeb ? 'Welcome!' : 'Welcome back, dev!',
                                        bottomPadding: 10,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.arrowRightArrowLeft,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          BLTextButton(
                                            onPressed: () {
                                              setState(() {
                                                useEmail = !useEmail;
                                              });
                                            },
                                            child: BLText(
                                              useEmail ? 'Login with phone' : 'Login with email',
                                              color: Colors.amber,
                                              bold: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: useEmail,
                                        child: BLTextBox(
                                          controller: emailController,
                                          labelText: 'Email',
                                          onFieldSubmitted: (p0) => submit(context),
                                          prefixIcon: const Icon(
                                            FontAwesomeIcons.envelope,
                                            color: Colors.white,
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (email) {
                                            return validator.validateEmail(email?.trim());
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: !useEmail && !kIsWeb,
                                        child: BLTextBox(
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 3),
                                            child: BLText(
                                              '+63',
                                              bold: true,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onFieldSubmitted: (p0) => submit(context),
                                          controller: phoneController,
                                          maxLength: 10,
                                          labelText: 'Phone number',
                                          keyboardType: TextInputType.phone,
                                          validator: (phoneNum) => validator.validatePhoneNum(phoneNum, required: true),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Visibility(
                                        visible: useEmail,
                                        child: BLTextBox(
                                          controller: passwordController,
                                          labelText: 'Password',
                                          onFieldSubmitted: (p0) => submit(context),
                                          prefixIcon: const Icon(
                                            FontAwesomeIcons.lock,
                                            color: Colors.white,
                                          ),
                                          isObscure: true,
                                          keyboardType: TextInputType.visiblePassword,
                                          validator: (password) {
                                            return validator.validatePassword(password?.trim());
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: !useEmail,
                                        child: BLTextBox(
                                          controller: otpController,
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          prefixIcon: const Icon(Icons.numbers),
                                          labelText: '6-digit code',
                                          keyboardType: TextInputType.number,
                                          maxLength: 6,
                                          validator: (otp) => validator.validateOtp(otp),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BLTextButton(
                                              onPressed: () async {
                                                bool? result = await showDialog(
                                                    context: context,
                                                    builder: (context) => ForgotPasswordDialog(
                                                          useEmail: useEmail,
                                                        ));
                                                if (result != null) {
                                                  toast.showToast('A reset link was sent to your email.', type: NotifType.info);
                                                }
                                              },
                                              child: const BLText(
                                                'Forgot password?',
                                                size: 15,
                                              )),
                                          Visibility(
                                            visible: !useEmail,
                                            child: BLTextButton(
                                              onPressed: () {
                                                if (validator.validatePhoneNum(phoneController.text, required: true) != null) {
                                                  toast.showToast('Please provide phone number.', type: NotifType.error);
                                                } else if (!otpCooldownTimer.isActive) {
                                                  sendOTP(context);
                                                }
                                              },
                                              child: BLText(
                                                'Send OTP ${otpCooldownTimer.isActive ? '($secondsLeft)' : ''}',
                                                color: otpCooldownTimer.isActive ? Colors.grey : null,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      BLButton(
                                          type: useEmail
                                              ? BtnType.green
                                              : !firstOTPSent
                                                  ? BtnType.grey
                                                  : processing
                                                      ? BtnType.grey
                                                      : BtnType.green,
                                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                          onPressed: () {
                                            if (firstOTPSent == false && !useEmail) {
                                              toast.showToast('Send OTP first', type: NotifType.error);
                                              return;
                                            }
                                            submit(context);
                                          },
                                          child: const BLText(
                                            'Login',
                                            color: Colors.white,
                                          )),
                                      if (!kIsWeb)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BLTextButton(
                                                onPressed: () => nav.pushReplace(context, const Signup()),
                                                child: const BLText(
                                                  'Create an account',
                                                  underlined: true,
                                                  size: 15,
                                                ))
                                          ],
                                        ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: processing,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  child: const BLLoading(message: 'Logging in ...'),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    if (context.mounted) {
      toast.dismissAllToast();
    }
    super.didPop();
  }

  @override
  void didPushNext() {
    if (context.mounted) {
      toast.dismissAllToast();
    }
    super.didPushNext();
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

  @override
  void initState() {
    otpCooldownTimer = createTimer();
    otpCooldownTimer.cancel();
    validator = ref.read(textValidatorProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  Future<void> submit(BuildContext context) async {
    if (processing) return;
    toggleProcessing(true);
    if (_loginFormKey.currentState!.validate()) {
      final error = useEmail
          ? await auth.loginEmail(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            )
          : await auth.loginPhone(
              phone: emailController.text.trim(),
              code: otpController.text.trim(),
              verificationID: verificationID,
            );
      ref.invalidate(authServiceProvider);
      ref.invalidate(authChangesProvider);
      if (error == null) {
        final loginAlert = ref.read(loginAlertProvider.notifier);
        await loginAlert.send();
        // if (result != null) {
        //   if (!context.mounted) return;
        //   toast.showToast(result, type: NotifType.error);
        // }
        if (kIsWeb) {
          if (!context.mounted) return;
          context.go('/dashboard');
        } else {
          // final settings = await ref.read(SettingsProvider(widget.accountType).future);

          if (!context.mounted) return;
          nav.pushAndRemove(context, const Checkpoint());
        }
      } else {
        if (!context.mounted) return;
        toast.showToast(
          error,
          type: NotifType.error,
        );
      }
    }
    toggleProcessing(false);
  }

  void toggleProcessing(bool newState) {
    setState(() {
      processing = newState;
    });
  }

  void sendOTP(BuildContext context) {
    // get from token firebase admin sdk
    // send sms using semaphore
    if (firstOTPSent == false) {
      setState(() {
        firstOTPSent = true;
      });
    }
    setState(() {
      otpCooldownTimer = createTimer();
    });
    toast.showToast('OTP sent!', type: NotifType.info);
    const verificationID = '';
    setState(() {
      this.verificationID = verificationID;
    });
  }
}
