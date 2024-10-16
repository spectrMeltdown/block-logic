import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordDialog extends ConsumerStatefulWidget {
  final bool useEmail;
  const ForgotPasswordDialog({required this.useEmail, super.key});

  @override
  ConsumerState<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<ForgotPasswordDialog> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Widget errorMsg = const BlankWidget();
  bool processing = false;
  late final AuthService auth;
  late final CustomNavigation nav;
  late final Toast toast;
  late final TextValidator validator;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return BLDialog(
        child: Form(
      key: formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width * 0.3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLSmallTitle('Enter your ${widget.useEmail ? 'email' : 'phone'}:'),
            const SizedBox(height: 10),
            Visibility(
              visible: widget.useEmail,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kIsWeb
                        ? width >= desktopMin
                            ? 40
                            : width >= tabletMin
                                ? 20
                                : 10
                        : 0),
                child: BLTextBox(
                  controller: emailController,
                  labelText: 'Email',
                  onFieldSubmitted: (p0) => sendLink(),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    return validator.validateEmail(email?.trim());
                  },
                ),
              ),
            ),
            Visibility(
              visible: !kIsWeb && !widget.useEmail,
              child: BLTextBox(
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: BLText(
                    '+63',
                    bold: true,
                    color: Colors.white,
                  ),
                ),
                onFieldSubmitted: (p0) => sendLink(),
                controller: phoneController,
                maxLength: 10,
                labelText: 'Phone number',
                keyboardType: TextInputType.phone,
                validator: (phoneNum) => validator.validatePhoneNum(phoneNum),
              ),
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
    super.initState();
    validator = ref.read(textValidatorProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  Future<void> sendLink() async {
    if (processing) return;
    toggleProcessing();
    if (!formKey.currentState!.validate()) {
      toggleProcessing();
      return;
    }
    String? result = widget.useEmail ? await auth.forgotPass(emailController.text.trim()) : await auth.forgotPass(phoneController.text.trim(), useEmail: false);
    if (result != null) {
      setState(() {
        errorMsg = BLText(
          result,
          color: Colors.red,
        );
      });
    } else {
      toggleProcessing();
      if (!mounted) return;
      nav.pop(context);
      if (!context.mounted) return;
      toast.showToast(context, 'A password reset link was sent to ${widget.useEmail ? emailController.text : phoneController.text}.', type: NotifType.info);
    }
    toggleProcessing();
  }
}
