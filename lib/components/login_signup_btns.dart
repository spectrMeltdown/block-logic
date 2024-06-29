import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:flutter/material.dart';

class BLLoginSignupBtns extends StatelessWidget {
  const BLLoginSignupBtns({super.key, this.mainAxisAlignment = MainAxisAlignment.center});
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        BLButton(onPressed: () => Utils.push(context, const Login()), child: const BLText('Login')),
        const SizedBox(
          width: 15,
        ),
        BLButton(onPressed: () => Utils.push(context, const Signup()), child: const BLText('Signup'))
      ],
    );
  }
}
