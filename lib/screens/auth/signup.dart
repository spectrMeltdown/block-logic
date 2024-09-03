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
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:block_logic/screens/terms_and_conditions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> with RouteAware {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  late Widget msg;
  late Toast toast;
  late final TextValidator validator;
  late final CustomNavigation nav;
  late final AuthService auth;
  late final ReportsManager reportsManager;
  bool processing = false;
  bool checkedTerms = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (!processing) {
          nav.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Background(
                child: SingleChildScrollView(
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
                                    const SizedBox(height: 30),
                                    BLTextBox(
                                      controller: displayNameController,
                                      hintText: 'Display Name',
                                      maxLength: 20,
                                      prefixIcon: const Icon(
                                        Icons.abc,
                                        color: Colors.white,
                                      ),
                                      keyboardType: TextInputType.name,
                                      validator: (name) => validator.validateDisplayName(name),
                                    ),
                                    const SizedBox(height: 15),
                                    BLTextBox(
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: BLText(
                                          '+63',
                                          bold: true,
                                          color: Colors.white,
                                        ),
                                      ),
                                      controller: phoneNumController,
                                      maxLength: 10,
                                      hintText: 'Phone number (optional)',
                                      keyboardType: TextInputType.phone,
                                      validator: (phoneNum) => validator.validatePhoneNum(phoneNum),
                                    ),
                                    const SizedBox(height: 15),
                                    BLTextBox(
                                      controller: emailController,
                                      hintText: 'Email',
                                      prefixIcon: const Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.white,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (email) {
                                        return validator.validateEmail(email?.trim());
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                    BLTextBox(
                                      controller: passwordController,
                                      hintText: 'Password',
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
                                    const SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        BLCheckbox(
                                          onPressed: () => checkedTerms = !checkedTerms,
                                        ),
                                        const SizedBox(width: 10),
                                        BLRichText([
                                          const TextSpan(text: 'I agree to the '),
                                          TextSpan(
                                              style: const TextStyle(decoration: TextDecoration.underline),
                                              text: 'terms & conditions',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => nav.push(context, const TermsAndConditions())),
                                        ])
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    msg,
                                    const SizedBox(height: 15),
                                    BLButton(
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                        onPressed: () async {
                                          if (processing == true) return;
                                          setState(() {
                                            processing = true;
                                          });
                                          if (_signupFormKey.currentState!.validate()) {
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
                                            if (!context.mounted) return;
                                            final error = await auth.createAccount(
                                                type: AccountType.user,
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                                phoneNum: phoneNumController.text.trim(),
                                                displayName: displayNameController.text.trim());
                                            if (error == null) {
                                              await reportsManager.add(ReportType.users);
                                              if (!context.mounted) return;
                                              nav.pushReplace(context, const Checkpoint());
                                            } else {
                                              if (!context.mounted) return;
                                              toast.showToast(
                                                error,
                                                type: NotifType.error,
                                              );
                                            }
                                          }
                                          setState(() {
                                            processing = false;
                                          });
                                        },
                                        child: const BLText(
                                          'Create account',
                                          color: Colors.white,
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        BLTextButton(
                                            onPressed: () => nav.pushReplace(
                                                context,
                                                const Login(
                                                  accountType: FirestoreCollections.users,
                                                )),
                                            child: const BLText(
                                              'Login to existing account',
                                              underlined: true,
                                              size: 15,
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
            )),
            Visibility(
                visible: processing,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
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
    toast.dismissAllToast();
    super.didPop();
  }

  @override
  void didPushNext() {
    toast.dismissAllToast();
    super.didPushNext();
  }

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    nav = ref.read(customNavigationProvider);
    auth = ref.read(authServiceProvider.notifier);
    reportsManager = ref.read(reportsManagerProvider.notifier);
    msg = const BlankWidget();
    super.initState();
  }
}
