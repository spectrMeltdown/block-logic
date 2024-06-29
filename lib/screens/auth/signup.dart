import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/checkbox.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/logic/validators.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> implements Debounce {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  @override
  bool processing = false;

  @override
  Widget build(BuildContext context) {
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
                            prefixIcon: const Icon(
                              Icons.abc,
                              color: Colors.white,
                            ),
                            keyboardType: TextInputType.name,
                            validator: (displayName) {
                              return validateDisplayName(displayName?.trim());
                            },
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
                              return validateEmail(email?.trim());
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
                              return validatePassword(password?.trim());
                            },
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              BLCheckbox(),
                              SizedBox(width: 10),
                              BLTextSpan([
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                    style: TextStyle(decoration: TextDecoration.underline),
                                    text: 'terms & conditions',
                                    recognizer: TapGestureRecognizer()..onTap = () => {}),
                              ])
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          BLButton(
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              onPressed: () async {
                                if (_signupFormKey.currentState!.validate()) {
                                  if (processing == true) {
                                    return;
                                  }
                                  processing = true;
                                  await AuthService.createAccount(context,
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      displayName: displayNameController.text.trim());
                                  processing = false;
                                }
                              },
                              child: const BLText(
                                'Submit',
                                color: Colors.white,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BLTextButton(
                                  onPressed: () => Utils.pushReplace(context, const Login()),
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
