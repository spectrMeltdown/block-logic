import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogChallengeInfo extends ConsumerWidget {
  const DialogChallengeInfo({required this.challenge, super.key});
  final Challenge challenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BLDialog(
        child: Column(
      children: [BLText('')],
    ));
  }
}
