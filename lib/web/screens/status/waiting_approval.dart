import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaitingApproval extends ConsumerStatefulWidget {
  const WaitingApproval({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WaitingApprovalState();
}

class _WaitingApprovalState extends ConsumerState<WaitingApproval> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BLSmallTitle('Awaiting admin approval'),
            BLText(
                'This account was created by admin, but is waiting approval.')
          ],
        ),
      )),
    );
  }
}
