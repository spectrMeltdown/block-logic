import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLLoginSignupBtns extends ConsumerWidget {
  final MainAxisAlignment mainAxisAlignment;
  const BLLoginSignupBtns(
      {super.key, this.mainAxisAlignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(customNavigationProvider);
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        BLButton(
            onPressed: () => nav.push(
                context,
                const Login(
                  accountType: FirestoreCollections.users,
                )),
            child: const BLText(
              'Login',
              color: Colors.white,
            )),
        const SizedBox(
          width: 15,
        ),
        BLButton(
            onPressed: () => nav.push(context, const Signup()),
            child: const BLText(
              'Signup',
              color: Colors.white,
            ))
      ],
    );
  }
}
