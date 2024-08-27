import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/web/components/logout_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Unauthorized extends ConsumerStatefulWidget {
  const Unauthorized({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnauthorizedState();
}

class _UnauthorizedState extends ConsumerState<Unauthorized> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 100,
          ),
          SizedBox(height: 15),
          BLSmallTitle('Not Authorized'),
          BLText('This account is not registered as an admin.'),
          SizedBox(height: 25),
          Center(child: LogoutBtn())
        ],
      ))),
    );
  }
}
