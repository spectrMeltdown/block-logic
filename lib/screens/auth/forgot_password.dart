import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Widget errorMsg = const BlankWidget();
  bool processing = false;
  late final AuthService auth;
  late final CustomNavigation nav;
  late final Toast toast;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final validator = ref.read(textValidatorProvider.notifier);
    return BLDialog(
        child: Form(
      key: formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width * 0.3, maxHeight: height * 0.25),
        child: Column(
          children: [
            const BLSmallTitle('Enter your email:'),
            const SizedBox(height: 10),
            BLTextBox(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              labelText: 'Email address',
              onFieldSubmitted: (p0) => sendLink(),
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
                    onPressed: () => sendLink(),
                    child: const BLText(
                      'Submit',
                      color: Colors.green,
                    )),
                const SizedBox(width: 10)
              ],
            )
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }

  Future<void> sendLink() async {
    if (processing) return;
    processing = true;
    if (!formKey.currentState!.validate()) {
      processing = false;
      return;
    }
    String? result = await auth.forgotPass(emailController.text.trim());
    if (result != null) {
      setState(() {
        errorMsg = BLText(
          result,
          color: Colors.red,
        );
      });
    } else {
      processing = false;
      if (!mounted) return;
      nav.pop(context);
      toast.showToast('A password reset link was sent to ${emailController.text}.', type: NotifType.info);
    }
    processing = false;
  }
}
