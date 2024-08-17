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
    return Container();
  }
}
