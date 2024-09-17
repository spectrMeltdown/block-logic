import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengeSelector extends ConsumerStatefulWidget {
  const ChallengeSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChallengeSelectorState();
}

class _ChallengeSelectorState extends ConsumerState<ChallengeSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
              child: Column(
        children: [BLSmallTitle('Select challenges')],
      ))),
    );
  }
}
