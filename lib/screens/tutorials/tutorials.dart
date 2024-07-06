import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/card.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/ui.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/tutorials/variables.dart';
import 'package:flutter/material.dart';

class Tutorials extends StatelessWidget {
  const Tutorials({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Column(
        children: [
          const Row(
            children: [BLBackButton()],
          ),
          Expanded(
              child: Column(
            children: [
              const BLTitle('Tutorials'),
              BLCard(
                  onPressed: () => Utils.push(context, const VariablesScreen()),
                  blockType: BlockType.variables,
                  child: const BLText('Variables')),
            ],
          )),
        ],
      )),
    );
  }
}
