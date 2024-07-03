import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text.dart';
import 'package:flutter/material.dart';

class Tutorials extends StatelessWidget {
  const Tutorials({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(child: Expanded(child: BLTitle('Tutorials'))),
    );
  }
}
