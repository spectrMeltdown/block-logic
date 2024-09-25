import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeEmail extends ConsumerStatefulWidget {
  const ChangeEmail({super.key});

  @override
  ConsumerState<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangeEmail> {
  late final String oldEmail;
  late final TextEditingController emailController;
  final passController = TextEditingController();
  late final AuthService auth;
  late final CustomNavigation nav;
  late final TextValidator validator;
  Widget msg = const BlankWidget();
  bool processing = false;
  bool usePass = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    oldEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    usePass = oldEmail.isEmpty;
    emailController = TextEditingController(text: oldEmail.isEmpty ? null : oldEmail);
    super.initState();
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  void updateMsg(String? error) {
    setState(() {
      msg = Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: BLText(
          error ?? '',
          color: Colors.red,
          alignCenter: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BLSmallTitle(usePass ? 'Enter new email & password' : 'Enter your new email'),
          const SizedBox(
            height: 10,
          ),
          BLTextBox(
            controller: emailController,
            labelText: 'Your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.mail,
              color: Colors.white,
            ),
            validator: (email) => validator.validateEmail(email),
          ),
          const SizedBox(
            height: 10,
          ),
          if (usePass)
            BLTextBox(
              controller: passController,
              keyboardType: TextInputType.visiblePassword,
              labelText: 'Your secure password',
              isObscure: true,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              validator: (pass) => validator.validatePassword(pass),
            ),
          if (usePass)
            const SizedBox(
              height: 10,
            ),
          msg,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    if (processing) return;
                    Navigator.pop(context);
                  },
                  child: BLText(
                    'Cancel',
                    color: processing ? Colors.grey : Colors.red,
                  )),
              TextButton(
                  onPressed: () async {
                    if (processing) return;
                    toggleProcessing();
                    if (formKey.currentState!.validate()) {
                      final newEmail = emailController.text.trim();
                      if (oldEmail != newEmail) {
                        // link the credential first, user must first this error if exists
                        final error = await auth.linkEmailAndPass(
                          email: newEmail,
                          pass: passController.text.trim(),
                        );
                        if (error != null) {
                          updateMsg(error);
                        } else {
                          if (!context.mounted) return;
                          nav.pop(context);
                        }

                        if (!usePass) {
                          // for changing emails
                          final error = await auth.changeEmail(newEmail);
                          if (error != null) {
                            updateMsg(error);
                          } else {
                            if (!context.mounted) return;
                            nav.pop(context);
                          }
                        }
                      } else {
                        nav.pop(context);
                      }
                    }
                    toggleProcessing();
                  },
                  child: BLText(
                    'Save',
                    color: processing ? Colors.grey : Colors.green,
                  )),
              const SizedBox(
                width: 10,
              )
            ],
          )
        ],
      ),
    ));
  }
}
