import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DuplicateLogin extends ConsumerStatefulWidget {
  const DuplicateLogin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DuplicateLoginState();
}

class _DuplicateLoginState extends ConsumerState<DuplicateLogin> {
  late final AuthService auth;
  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: BLSmallTitle('You are already logged in on another device.'),
              ),
              BLButton(
                type: BtnType.red,
                onPressed: () async {
                  await auth.logout();
                },
                child: const BLText(
                  'Logout',
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
