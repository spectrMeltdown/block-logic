import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController emailController = TextEditingController(text: 'your email');

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BLSmallTitle('Enter your new email'),
        SizedBox(
          height: 10,
        ),
        BLTextBox(
          controller: emailController,
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: BLText(
                  'Cancel',
                  color: Colors.red,
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: BLText(
                  'Save',
                  color: Colors.green,
                )),
            SizedBox(
              width: 10,
            )
          ],
        )
      ],
    ));
  }
}
