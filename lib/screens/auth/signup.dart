import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text_button.dart';
import 'package:block_logic/components/checkbox.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/screens/auth/login.dart';
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

class _SignupState extends ConsumerState<Signup> {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  late Widget msg;
  bool processing = false;
  bool checkedTerms = false;

  @override
  void initState() {
    msg = const BlankWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final validator = ref.read(textValidatorProvider);
    final nav = ref.read(navProvider);
    final auth = ref.read(authServiceProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(children: [BLBackButton()]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BLPanel(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _signupFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          const BLTitle(
                            'SIGNUP',
                            bottomPadding: 10,
                          ),
                          const BLText('Hello there, dev!'),
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
                            // no longer validating display name, as this doesn't
                            // need to be the same as real name
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
                              return validator
                                  .validatePassword(password?.trim());
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
                              BLTextSpan([
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                    text: 'terms & conditions',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => nav.push(
                                          context, const TermsAndConditions())),
                              ])
                            ],
                          ),
                          const SizedBox(height: 30),
                          msg,
                          const SizedBox(height: 15),
                          BLButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              onPressed: () async {
                                if (_signupFormKey.currentState!.validate()) {
                                  if (checkedTerms == false) {
                                    msg = const BLText(
                                      'You must agree to terms and conditions.',
                                      color: Colors.red,
                                    );
                                    setState(() {});
                                    return;
                                  } else {
                                    msg = const BlankWidget();
                                    setState(() {});
                                  }
                                  if (processing == true) {
                                    return;
                                  }

                                  processing = true;
                                  await auth.createAccount(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      phoneNum: phoneNumController.text.trim(),
                                      displayName:
                                          displayNameController.text.trim());
                                  processing = false;
                                }
                              },
                              child: const BLText(
                                'Create account',
                                color: Colors.white,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BLTextButton(
                                  onPressed: () =>
                                      nav.pushReplace(context, const Login()),
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
          ],
        ),
      )),
    );
  }
}
