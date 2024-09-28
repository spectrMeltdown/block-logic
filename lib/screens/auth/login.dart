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
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/login_alert.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/logic/testing.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/forgot_password.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

class Login extends ConsumerStatefulWidget {
  final FirestoreCollections accountType;
  const Login({required this.accountType, super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> with RouteAware {
  final emailController = kIsWeb && kDebugMode ? TextEditingController(text: 'diamadex@gmail.com') : TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = kIsWeb && kDebugMode ? TextEditingController(text: 'willow123') : TextEditingController();
  final otpController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  late final Toast toast;
  late final SharedPreferences sharedPref;
  late final AuthService auth;
  late final CustomNavigation nav;
  late final AccountService accountService;
  late final TextValidator validator;
  late Timer otpCooldownTimer;
  String verificationID = '';
  String resendToken = '';
  bool processing = false;
  bool useEmail = true;
  bool firstOTPSent = false;
  int secondsLeft = 30;

  @override
  Widget build(BuildContext context) {
    final mediaQ = MediaQuery.of(context);
    final width = mediaQ.size.width;

    return PopScope(
      canPop: !processing,
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
                        if (kDebugMode)
                          BLAdminButton(
                              type: AdminBtnType.grey,
                              child: const BLText('Populate Reports'),
                              onPressed: () async {
                                final testing = ref.read(testingProvider.notifier);
                                final result = await testing.populateReports(
                                    dateRange: DateTimeRange(
                                      start: DateTime(2024, 8, 1, 12, 0),
                                      end: DateTime.now(),
                                    ),
                                    number: 50);
                                if (result != null) {
                                  if (!context.mounted) return;
                                  toast.showToast(context, result, type: NotifType.error);
                                }
                              }),
                        if (!kIsWeb)
                          const Align(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: BLBackButton(),
                            ),
                          ),
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
                                      if (!kIsWeb)
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
                                          onFieldSubmitted: (p0) => submit(),
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
                                          onFieldSubmitted: (p0) => submit(),
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
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
                                          onFieldSubmitted: (p0) => submit(),
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
                                        // mainAxisAlignment: useEmail ? MainAxisAlignment.start : MainAxisAlignment.end,
                                        children: [
                                          if (useEmail)
                                            BLTextButton(
                                                onPressed: () async {
                                                  bool? result = await showDialog(
                                                      context: context,
                                                      builder: (context) => ForgotPasswordDialog(
                                                            useEmail: useEmail,
                                                          ));
                                                  if (result != null) {
                                                    if (!context.mounted) return;
                                                    toast.showToast(context, 'A reset link was sent to your email.', type: NotifType.info);
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
                                                  if (!context.mounted) return;
                                                  toast.showToast(context, 'Please provide phone number.', type: NotifType.error);
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
                                              if (!context.mounted) return;
                                              toast.showToast(context, 'Send OTP first', type: NotifType.error);
                                              return;
                                            }
                                            submit();
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
                  color: Colors.black.withOpacity(0.9),
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
      toast.dismissAllToast(context);
    }
    super.didPop();
  }

  @override
  void didPushNext() {
    if (context.mounted) {
      toast.dismissAllToast(context);
    }
    super.didPushNext();
  }

  @override
  void dispose() {
    otpCooldownTimer.cancel();
    super.dispose();
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
    otpCooldownTimer = Timer(Duration.zero, () {});
    otpCooldownTimer.cancel();
    accountService = ref.read(accountServiceProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    sharedPref = ref.read(sharedPrefProvider);
    super.initState();
  }

  Future<void> submit() async {
    if (processing) return;
    toggleProcessing(true);
    if (_loginFormKey.currentState!.validate()) {
      if (!useEmail) {
        final phoneExists = await auth.checkPhoneExists(phoneController.text.trim());
        if (phoneExists != null) {
          if (!mounted) return;
          toast.showToast(context, phoneExists, type: NotifType.error);
          toggleProcessing(false);
          return;
        }
      }
      final error = useEmail
          ? await auth.loginEmail(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            )
          : await auth.loginPhone(
              // phone: phoneController.text.trim(),
              code: otpController.text.trim(),
              verificationID: verificationID,
            );
      if (error == null) {
        // refresh auth providers
        ref.invalidate(authServiceProvider);
        ref.invalidate(authChangesProvider);

        // remove used tokens
        // sharedPref.remove('resendToken');
        // sharedPref.remove('verificationID');

        // create sessionID
        if (!kIsWeb) {
          final sessionID = const UuidV4().generate();
          // save sessionID to shared_pref
          auth.saveSessionID(sessionID);
        }
        final loginAlert = ref.read(loginAlertProvider.notifier);
        await loginAlert.send();
        // if (result != null) {
        //   if (!context.mounted) return;
        //   if(!context.mounted) return; toast.showToast(context,result, type: NotifType.error);
        // }
        if (kIsWeb) {
          if (!mounted) return;
          context.go('/dashboard');
        } else {
          // final settings = await ref.read(SettingsProvider(widget.accountType).future);

          if (!mounted) return;
          nav.pushAndRemove(context, const Checkpoint());
        }
      } else {
        if (!mounted) return;
        toast.showToast(
          context,
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

  void updateCallBack({
    required String resendToken,
    required String verificationID,
  }) async {
    this.resendToken = resendToken;
    this.verificationID = verificationID;
  }

  void sendOTP(BuildContext context) async {
    // get from token firebase admin sdk
    // send sms using semaphore
    if (processing || otpCooldownTimer.isActive) return;
    processing = true;
    // var result = null;
    final result = await accountService.verifyPhoneNumber(
      context: context,
      phoneNumber: '+63${phoneController.text.trim()}',
      resendToken: resendToken,
      type: AccountType.user,
      updateCallBack: updateCallBack,
    );
    if (result != null) {
      if (!context.mounted) return;
      toast.showToast(context, result, type: NotifType.error);
    } else {
      // if(!context.mounted) return; toast.showToast(context,'OTP sent!', type: NotifType.success);
      if (firstOTPSent == false) {
        setState(() {
          firstOTPSent = true;
        });
      }
      setState(() {
        otpCooldownTimer = createTimer();
      });
      // resendToken = sharedPref.getString('resendToken')!;
      // verificationID = sharedPref.getString('verificationID')!;
    }
    // otp = otpService.getOTP().toString();
    // final result = await sms.send(phoneNum, otp!);

    processing = false;
  }
}
