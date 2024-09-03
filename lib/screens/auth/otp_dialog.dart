import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPDialog extends ConsumerStatefulWidget {
  const OTPDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPDialogState();
}

class _OTPDialogState extends ConsumerState<OTPDialog> {
  final otpController = TextEditingController();
  late final AccountService accountService;
  late final AsyncValue<UserAccount?> user;
  late final TextValidator validator;
  late final AuthService authService;
  final formKey = GlobalKey<FormState>();
  bool processing = false;

  void submit() async {
    if (processing) return;
    setState(() {
      processing = true;
    });
    if (formKey.currentState!.validate()) {}
    setState(() {
      processing = false;
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
          BLText('Please enter the OTP we sent:'),
          BLTextBox(
            controller: otpController,
            onFieldSubmitted: (p0) => submit(),
            validator: (value) => validator.validateOtp(value),
            keyboardType: TextInputType.number,
          ),
          BLTextButton(onPressed: () {}, child: BLText('Resend')),
        ],
      ),
    ));
  }
}
