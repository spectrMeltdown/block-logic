import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text.dart';
import 'package:flutter/material.dart';

class CreatorMode extends StatelessWidget {
  const CreatorMode({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(child: Expanded(child: BLTitle('Creator Mode'))),
    );
  }
}
