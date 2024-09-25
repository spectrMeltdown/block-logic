import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
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
  late final CustomNavigation nav;
  late final AuthService auth;
  late final TextValidator validator;
  bool processing = false;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
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
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.white,
            ),
            validator: (pass) => validator.validatePassword(pass),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => nav.pop(context),
                  child: const BLText(
                    'Cancel',
                    color: Colors.red,
                  )),
              TextButton(
                  onPressed: () {
                    if (processing) return;
                    toggleProcessing();
                    if (formKey.currentState!.validate()) {
                      auth.changePass(passController.text.trim());
                    }
                    toggleProcessing();
                  },
                  child: const BLText(
                    'Save',
                    color: Colors.green,
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

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }
}
