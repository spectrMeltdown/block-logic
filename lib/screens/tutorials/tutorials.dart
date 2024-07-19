import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/spaced_col.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/tutorials/classes.dart';
import 'package:block_logic/screens/tutorials/conditionals_and_loops.dart';
import 'package:block_logic/screens/tutorials/data_type_and_literals.dart';
import 'package:block_logic/screens/tutorials/functions.dart';
import 'package:block_logic/screens/tutorials/operators.dart';
import 'package:block_logic/screens/tutorials/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tutorials extends ConsumerWidget {
  const Tutorials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(navProvider);
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
                  onPressed: () => nav.push(context, const Variables()),
                  blockType: BlockType.variables,
                  child: const BLText(
                    'Variables',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () =>
                      nav.push(context, const DataTypesAndLiterals()),
                  blockType: BlockType.literals,
                  height: 100,
                  child: const BLText(
                    'Data Types & \nLiterals',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => nav.push(context, const Functions()),
                  blockType: BlockType.functions,
                  child: const BLText(
                    'Functions',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => nav.push(context, const Classes()),
                  blockType: BlockType.classes,
                  child: const BLText(
                    'Classes',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () => nav.push(context, const Operators()),
                  blockType: BlockType.operators,
                  child: const BLText(
                    'Operators',
                    size: 23,
                    color: Colors.white,
                  )),
              BLCard(
                  onPressed: () =>
                      nav.push(context, const ConditionalsAndLoops()),
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
