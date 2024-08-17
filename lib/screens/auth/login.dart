import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/account_settings.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/login_alert.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/forgot_password.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  late Toast toast;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final validator = ref.read(textValidatorProvider);
    final nav = ref.read(customNavigationProvider);
    final auth = ref.read(authServiceProvider.notifier);
    final settings = ref.read(SettingsProvider(widget.accountType).future);
    final width = MediaQuery.of(context).size.width;

    Future<void> onPressed() async {
      if (_loginFormKey.currentState!.validate()) {
        //toast.dismissAllToast();
        toast.showToast('Logging in', type: NotifType.info);
        final error = await auth.login(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        if (error == null) {
          final awaitedSettings = await settings;
          final loginAlert =
              ref.read(LoginAlertProvider(awaitedSettings).notifier);
          final result = await loginAlert.send();
          if (result != null) {
            if (!context.mounted) return;
            toast.showToast(result, type: NotifType.error);
          }
          if (!context.mounted) return;
          if (kIsWeb) {
            context.go('/');
          }
          nav.pushReplace(context, const MainMenuScreen());
        } else {
          if (!context.mounted) return;
          toast.showToast(
            error,
            type: NotifType.error,
          );
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!kIsWeb) const Row(children: [BLBackButton()]),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BLPanel(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kIsWeb ? 50 : 15,
                    vertical: kIsWeb ? 50 : 35,
                  ),
                  child: Form(
                    key: _loginFormKey,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: width / 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          const BLTitle(
                            kIsWeb ? 'Welcome!' : 'Welcome back, dev!',
                            bottomPadding: 10,
                          ),
                          const SizedBox(height: 30),
                          BLTextBox(
                            controller: emailController,
                            hintText: 'Email',
                            onFieldSubmitted: (p0) {
                              if (processing == true) return;
                              processing = true;
                              onPressed();
                              processing = false;
                            },
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
                            onFieldSubmitted: (p0) {
                              if (processing == true) return;
                              processing = true;
                              onPressed();
                              processing = false;
                            },
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
                                    String? result = await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ForgotPasswordDialog());
                                    if (result == '') {}
                                    processing = false;
                                  },
                                  child: const BLText(
                                    'Forgot password?',
                                    size: 15,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          BLButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10),
                              onPressed: () async {
                                if (processing == true) return;
                                processing = true;
                                onPressed();
                                processing = false;
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
                                    onPressed: () => nav.pushReplace(
                                        context, const Signup()),
                                    child: const BLText(
                                      'Create an account instead',
                                      underlined: true,
                                      size: 15,
                                    ))
                              ],
                            ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ],
      )),
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
    super.initState();
  }
}
