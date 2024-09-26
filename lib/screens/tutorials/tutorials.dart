import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/card/tutorial_item.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/tutorials/classes_and_objects.dart';
import 'package:block_logic/screens/tutorials/conditionals_and_loops.dart';
import 'package:block_logic/screens/tutorials/data_type_and_literals.dart';
import 'package:block_logic/screens/tutorials/functions.dart';
import 'package:block_logic/screens/tutorials/keywords.dart';
import 'package:block_logic/screens/tutorials/operators.dart';
import 'package:block_logic/screens/tutorials/tutorial_challenge_selector.dart';
import 'package:block_logic/screens/tutorials/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tutorials extends ConsumerWidget {
  const Tutorials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return Scaffold(
      body: Background(
          child: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: BLBackButton(),
            ),
            const BLTitle('Tutorials'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLCard(
                        color: Colors.teal,
                        onPressed: () {
                          nav.push(context, const TutorialChallengeSelector());
                        },
                        child: const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: BLSmallTitle('Practice'),
                        ))),
                    const SizedBox(
                      height: 12,
                    ),
                    ...List.generate(TutorialType.values.length, (i) {
                      final tutorial = getData(TutorialType.values[i]);
                      return Column(
                        children: [
                          TutorialItem(
                            onPressed: () => nav.push(context, tutorial[0]),
                            type: TutorialType.values[i],
                            childText: tutorial[1],
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      );
                    })
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      )),
    );
  }

  List<dynamic> getData(TutorialType type) {
    switch (type) {
      case TutorialType.dataTypesAndliterals:
        return [const DataTypesAndLiterals(), 'Data Types\n& Literals'];
      case TutorialType.functions:
        return [const Functions(), 'Functions'];
      case TutorialType.conditionalsAndLoops:
        return [const ConditionalsAndLoops(), 'Conditionals\n& Loops'];
      case TutorialType.classesAndObjects:
        return [const ClassesAndObjects(), 'Classes & Objects'];
      case TutorialType.variables:
        return [const Variables(), 'Variables'];
      case TutorialType.operators:
        return [const Operators(), 'Operators'];
      case TutorialType.keywords:
        return [const Keywords(), 'Keywords'];
    }
  }
}
