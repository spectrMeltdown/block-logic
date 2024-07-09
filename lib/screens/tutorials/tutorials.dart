import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/card.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/logic/ui.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/tutorials/classes.dart';
import 'package:block_logic/screens/tutorials/conditionals_and_loops.dart';
import 'package:block_logic/screens/tutorials/data_type_and_literals.dart';
import 'package:block_logic/screens/tutorials/functions.dart';
import 'package:block_logic/screens/tutorials/operators.dart';
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
              child: SpacedColumn(
            spacing: 15,
            children: [
              const BLTitle('Tutorials'),
              BLCard(
                  onPressed: () => Utils.push(context, const Variables()),
                  blockType: BlockType.variables,
                  child: const BLText(
                    'Variables',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => Utils.push(context, const DataTypesAndLiterals()),
                  blockType: BlockType.literals,
                  height: 100,
                  child: const BLText(
                    'Data Types & \nLiterals',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => Utils.push(context, const Functions()),
                  blockType: BlockType.functions,
                  child: const BLText(
                    'Functions',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => Utils.push(context, const Classes()),
                  blockType: BlockType.classes,
                  child: const BLText(
                    'Classes',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => Utils.push(context, const Operators()),
                  blockType: BlockType.operators,
                  child: const BLText(
                    'Operators',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => Utils.push(context, const ConditionalsAndLoops()),
                  blockType: BlockType.condLoops,
                  height: 100,
                  child: const BLText(
                    'Conditionals &\nLoops',
                    size: 23,
                    color: Colors.white,
                  )),
            ],
          )),
        ],
      )),
    );
  }
}
