import 'dart:async';

import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/checkbox.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:block_logic/screens/terms_and_conditions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> with RouteAware {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final phoneNumController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  late Widget msg;
  late Timer timer;
  late final Toast toast;
  late final SharedPreferences sharedPref;
  late final AccountService accountService;
  late final TextValidator validator;
  late final CustomNavigation nav;
  late final AuthService auth;
  late final ReportsManager reportsManager;
  int seconds = 30;
  bool processing = false;
  bool checkedTerms = false;
  bool useEmail = true;
  bool firstOTPSent = false;
  String verificationID = '';
  String resendToken = '';

  @override
  void initState() {
    super.initState();
    toast = ref.read(toastProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    reportsManager = ref.read(reportsManagerProvider.notifier);
    accountService = ref.read(accountServiceProvider.notifier);
    sharedPref = ref.read(sharedPrefProvider);
    timer = Timer(Duration.zero, () {});
    timer.cancel();
    msg = const BlankWidget();
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
      phoneNumber: '+63${phoneNumController.text.trim()}',
      resendToken: resendToken,
      type: AccountType.user,
      updateCallBack: updateCallBack,
    );
    if (result != null) {
      if (!mounted) return;
      toast.showToast(context, result, type: NotifType.error);
    } else {
      if (firstOTPSent == false) {
        setState(() {
          firstOTPSent = true;
        });
      }
      setState(() {
        timer = createTimer();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !processing,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Background(
                child: SafeArea(
              child: Scrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        const Row(children: [BLBackButton()]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BLPanel(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                  child: Form(
                                    key: _signupFormKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 5),
                                        const BLTitle(
                                          'Hello there, dev!',
                                          bottomPadding: 10,
                                        ),
                                        const SizedBox(height: 10),
                                        BLTextButton(
                                            onPressed: () {
                                              setState(() {
                                                useEmail = !useEmail;
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.arrowRightArrowLeft,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                BLText(
                                                  useEmail ? 'Signup with phone' : 'Signup with email',
                                                  color: Colors.amber,
                                                  bold: true,
                                                ),
                                              ],
                                            )),
                                        Visibility(
                                          visible: useEmail,
                                          child: BLTextBox(
                                            maxLength: 50,
                                            controller: emailController,
                                            labelText: 'Email',
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
                                          visible: !useEmail,
                                          child: BLTextBox(
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: BLText(
                                                '+63',
                                                bold: true,
                                                color: Colors.white,
                                              ),
                                            ),
                                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                            controller: phoneNumController,
                                            maxLength: 10,
                                            labelText: 'Phone number',
                                            keyboardType: TextInputType.phone,
                                            validator: (phoneNum) => validator.validatePhoneNum(phoneNum),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        BLTextBox(
                                          controller: displayNameController,
                                          labelText: 'Display Name',
                                          maxLength: 20,
                                          prefixIcon: const Icon(
                                            Icons.abc,
                                            color: Colors.white,
                                          ),
                                          keyboardType: TextInputType.name,
                                          validator: (name) => validator.validateDisplayName(name),
                                        ),
                                        const SizedBox(height: 15),
                                        Visibility(
                                          visible: useEmail,
                                          child: BLTextBox(
                                            maxLength: 50,
                                            controller: passwordController,
                                            labelText: 'Password',
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
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Visibility(
                                              visible: !useEmail,
                                              child: BLTextButton(
                                                onPressed: () {
                                                  if (validator.validatePhoneNum(phoneNumController.text, required: true) != null) {
                                                    if (!context.mounted) return;
                                                    toast.showToast(context, 'Please provide phone number.', type: NotifType.error);
                                                  } else if (!timer.isActive) {
                                                    sendOTP();
                                                  }
                                                },
                                                child: BLText(
                                                  'Send OTP ${timer.isActive ? '($seconds)' : ''}',
                                                  color: timer.isActive ? Colors.grey : Colors.lightBlue.shade100,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BLCheckbox(
                                              onPressed: () => checkedTerms = !checkedTerms,
                                            ),
                                            const SizedBox(width: 10),
                                            BLRichText([
                                              const TextSpan(text: 'I agree to the ', style: TextStyle(color: Colors.white)),
                                              TextSpan(
                                                style: TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.lightBlue.shade100,
                                                ),
                                                text: 'terms & conditions',
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => nav.push(
                                                        context,
                                                        const TermsAndConditions(),
                                                      ),
                                              ),
                                            ])
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        msg,
                                        const SizedBox(height: 15),
                                        BLButton(
                                            type: useEmail
                                                ? BtnType.green
                                                : !firstOTPSent
                                                    ? BtnType.grey
                                                    : processing
                                                        ? BtnType.grey
                                                        : BtnType.green,
                                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                            onPressed: () async {
                                              FocusScope.of(context).unfocus();
                                              if (processing == true) return;
                                              setState(() {
                                                processing = true;
                                              });
                                              if (firstOTPSent == false && !useEmail) {
                                                if (!context.mounted) return;
                                                toast.showToast(context, 'Send OTP first', type: NotifType.error);
                                              } else if (_signupFormKey.currentState!.validate()) {
                                                if (checkedTerms == false) {
                                                  setState(() {
                                                    msg = const BLText(
                                                      'You must agree to terms and conditions.',
                                                      color: Colors.deepOrange,
                                                    );
                                                  });
                                                  setState(() {
                                                    processing = false;
                                                  });
                                                  return;
                                                } else {
                                                  setState(() {
                                                    msg = const BlankWidget();
                                                  });
                                                }
                                                if (!useEmail) {
                                                  final phoneExists = await auth.checkPhoneNumDup(phoneNumController.text.trim());
                                                  if (phoneExists != null) {
                                                    if (!context.mounted) return;
                                                    toast.showToast(context, phoneExists, type: NotifType.error);
                                                    setState(() {
                                                      processing = false;
                                                    });
                                                    return;
                                                  }
                                                }
                                                if (!context.mounted) return;
                                                String? error;
                                                if (useEmail) {
                                                  error = await auth.createAccountWithEmail(
                                                    type: AccountType.user,
                                                    email: emailController.text.trim(),
                                                    password: passwordController.text.trim(),
                                                    displayName: displayNameController.text.trim(),
                                                  );
                                                } else {
                                                  error = await auth.createAccountWithPhone(
                                                    type: AccountType.user,
                                                    password: passwordController.text.trim(),
                                                    phoneNum: phoneNumController.text.trim(),
                                                    displayName: displayNameController.text.trim(),
                                                    smsCode: otpController.text.trim(),
                                                    verificationId: verificationID,
                                                  );
                                                }
                                                if (error == null) {
                                                  // sharedPref.remove('resendToken');
                                                  // sharedPref.remove('verificationID');
                                                  if (!kIsWeb) {
                                                    final sessionID = const UuidV4().generate();
                                                    // save sessionID to shared_pref
                                                    auth.saveSessionID(sessionID);
                                                    auth.uploadSessionID(sessionID);
                                                    await reportsManager.add(ReportType.basicUsers, 1);
                                                    await reportsManager.add(ReportType.users, 1);
                                                  }
                                                  if (!context.mounted) return;
                                                  nav.pushReplace(context, const Checkpoint());
                                                } else {
                                                  if (!context.mounted) return;
                                                  toast.showToast(
                                                    context,
                                                    error,
                                                    type: NotifType.error,
                                                  );
                                                }
                                              }
                                              setState(() {
                                                processing = false;
                                              });
                                            },
                                            child: BLText('Create account')),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BLTextButton(
                                                onPressed: () => nav.pushReplace(
                                                    context,
                                                    const Login(
                                                      accountType: FirestoreCollections.users,
                                                    )),
                                                child: BLText(
                                                  'Login to existing account',
                                                  underlined: true,
                                                  size: 15,
                                                  color: Colors.lightBlue.shade100,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
            Visibility(
                visible: processing,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const BLLoading(message: 'Creating account ...'),
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
    toast.dismissAllToast(context);
    super.didPop();
  }

  @override
  void didPushNext() {
    toast.dismissAllToast(context);
    super.didPushNext();
  }

  @override
  void dispose() {
    timer.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
