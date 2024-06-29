import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/logic/validators.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> implements Debounce {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
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
                      key: _loginFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          const BLTitle(
                            'LOGIN',
                            bottomPadding: 10,
                          ),
                          const BLText('Welcome back, dev!'),
                          const SizedBox(height: 30),
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
                          Row(
                            children: [
                              BLTextButton(
                                  onPressed: () async {},
                                  child: const BLText(
                                    'Forgot password?',
                                    size: 15,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          BLButton(
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  if (processing == true) {
                                    return;
                                  }
                                  processing = true;
                                  await AuthService.login(context,
                                      email: emailController.text.trim(), password: passwordController.text.trim());
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
                                  onPressed: () => Utils.pushReplace(context, const Signup()),
                                  child: const BLText(
                                    'Create an account instead',
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
