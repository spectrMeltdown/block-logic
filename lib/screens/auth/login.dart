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
import 'package:block_logic/logic/firebase_models/account_settings.dart';
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
  late final AuthService auth;
  late final Future<AccountSettings?> settings;
  late final CustomNavigation nav;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final validator = ref.read(textValidatorProvider.notifier);
    final mediaQ = MediaQuery.of(context);
    final width = mediaQ.size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (!processing) {
          nav.pop(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: kIsWeb ? Alignment.center : AlignmentDirectional.topStart,
          fit: StackFit.expand,
          children: [
            Background(
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
                                    const SizedBox(height: 30),
                                    BLTextBox(
                                      controller: emailController,
                                      hintText: 'Email',
                                      onFieldSubmitted: (p0) async {
                                        if (processing == true) return;
                                        toggleProcessing(true);
                                        await submit(context);
                                        toggleProcessing(false);
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
                                      onFieldSubmitted: (p0) async {
                                        if (processing == true) return;
                                        toggleProcessing(true);
                                        await submit(context);
                                        toggleProcessing(false);
                                      },
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
                                    Row(
                                      children: [
                                        BLTextButton(
                                            onPressed: () async {
                                              if (processing == true) return;
                                              toggleProcessing(true);
                                              bool? result = await showDialog(
                                                  context: context, builder: (context) => const ForgotPasswordDialog());
                                              if (result != null) {
                                                toast.showToast('A reset link was sent to your email.',
                                                    type: NotifType.info);
                                              }
                                              toggleProcessing(false);
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
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                        onPressed: () async {
                                          if (processing == true) return;
                                          toggleProcessing(true);
                                          await submit(context);
                                          toggleProcessing(false);
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
                                                'Create an account instead',
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
    auth = ref.read(authServiceProvider.notifier);
    settings = ref.read(SettingsProvider(widget.accountType).future);
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider);
    super.initState();
  }

  Future<void> submit(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      final error = await auth.login(email: emailController.text.trim(), password: passwordController.text.trim());
      if (error == null) {
        // TODO: Skipping login alerts for now. If needed later, move to bottom
        if (kIsWeb) {
          if (!context.mounted) return;
          context.go('/dashboard');
        } else {
          final awaitedSettings = await settings;
          final loginAlert = ref.read(LoginAlertProvider(awaitedSettings).notifier);
          final result = await loginAlert.send();
          if (result != null) {
            if (!context.mounted) return;
            toast.showToast(result, type: NotifType.error);
          }
          if (!context.mounted) return;
          nav.pushReplace(context, const MainMenuScreen());
        }
      } else {
        if (!context.mounted) return;
        toast.showToast(
          error,
          type: NotifType.error,
        );
      }
    }
  }

  void toggleProcessing(bool newState) {
    setState(() {
      processing = newState;
    });
  }
}
