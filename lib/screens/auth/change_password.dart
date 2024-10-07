import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  late final CustomNavigation nav;
  late final AuthService auth;
  late final TextValidator validator;
  bool processing = false;
  Widget msg = const BlankWidget();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BLSmallTitle('Enter your new password'),
            const SizedBox(
              height: 10,
            ),
            BLTextBox(
              controller: passController,
              keyboardType: TextInputType.visiblePassword,
              isObscure: true,
              labelText: 'Password',
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              validator: (pass) => validator.validatePassword(pass),
            ),
            const SizedBox(height: 10),
            BLTextBox(
              controller: confirmPassController,
              keyboardType: TextInputType.visiblePassword,
              isObscure: true,
              labelText: 'Confirm Password',
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              validator: (pass) => validator.validatePassword(pass),
            ),
            const SizedBox(height: 10),
            msg,
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => nav.pop(context),
                    child: BLText(
                      'Cancel',
                      color: processing ? Colors.grey : Colors.red,
                    )),
                TextButton(
                    onPressed: () async {
                      if (processing) return;
                      toggleProcessing();
                      if (formKey.currentState!.validate()) {
                        if (passController.text.trim() == confirmPassController.text.trim()) {
                          final error = await auth.changePass(passController.text.trim());
                          if (error != null) {
                            updateMsg(error);
                          } else {
                            if (!context.mounted) return;
                            nav.pop(context);
                          }
                        } else {
                          updateMsg('Passwords do not match.');
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
      ),
    ));
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
}
