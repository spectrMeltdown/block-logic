import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text_button.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/screens/auth/forgot_password.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final validator = ref.read(textValidatorProvider);
    final nav = ref.read(navProvider);
    final auth = ref.read(authServiceStateProvider.notifier);
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
                          Row(
                            children: [
                              BLTextButton(
                                  onPressed: () async {
                                    if (processing == true) return;
                                    processing = true;
                                    await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ForgotPasswordDialog());
                                    processing = false;
                                  },
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              onPressed: () async {
                                if (_loginFormKey.currentState!.validate()) {
                                  if (processing == true) {
                                    return;
                                  }
                                  processing = true;
                                  await auth.login(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
                                  processing = false;
                                }
                              },
                              child: const BLText(
                                'Login',
                                color: Colors.white,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BLTextButton(
                                  onPressed: () =>
                                      nav.pushReplace(context, const Signup()),
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
