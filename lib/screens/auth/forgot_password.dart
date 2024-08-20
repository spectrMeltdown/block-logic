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

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Widget errorMsg = const BlankWidget();
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final nav = ref.read(customNavigationProvider);
    final validator = ref.read(textValidatorProvider);
    return BLDialog(
        child: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BLSmallTitle('Enter your email:'),
          const SizedBox(height: 10),
          BLTextBox(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.mail,
            ),
            validator: (email) => validator.validateEmail(email),
          ),
          const SizedBox(height: 10),
          errorMsg,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const BLText(
                    'Cancel',
                    color: Colors.red,
                  )),
              TextButton(
                  onPressed: () async {
                    if (processing) return;
                    processing = true;
                    if (!formKey.currentState!.validate()) {
                      processing = false;
                      return;
                    }
                    String? result =
                        await auth.forgotPass(emailController.text.trim());
                    if (result != null) {
                      setState(() {
                        errorMsg = BLText(
                          result,
                          color: Colors.red,
                        );
                      });
                    } else {
                      if (context.mounted) nav.pop(context, true);
                    }
                    processing = false;
                  },
                  child: const BLText(
                    'Submit',
                    color: Colors.green,
                  )),
              const SizedBox(width: 10)
            ],
          )
        ],
      ),
    ));
  }
}
