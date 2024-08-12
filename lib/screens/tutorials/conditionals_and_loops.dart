import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionalsAndLoops extends ConsumerStatefulWidget {
  const ConditionalsAndLoops({super.key});

  @override
  ConsumerState<ConditionalsAndLoops> createState() =>
      _ConditionalsAndLoopsState();
}

class _ConditionalsAndLoopsState extends ConsumerState<ConditionalsAndLoops> {
  @override
  Widget build(BuildContext context) {
    final tutorialData = ref.read(tutorialDataProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: BLBackButton(),
          ),
          const Center(
            child: BLSmallTitle('Conditionals & Loops'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Conditionals allow programs to make decisions based on certain conditions. The most common conditional statement is if, which executes a block of code only if a specified condition is true. For example:\n\n
''', style: tutorialData.paragraphStyle),
                      const TextSpan(text: '''
if temperature > 30:
          print("It's hot outside!")\n\n
'''),
                      TextSpan(text: '''
This code checks if the temperature is greater than 30 and prints a message if the condition is true.\n
''', style: tutorialData.paragraphStyle),
                      TextSpan(text: '''
Loops enable repeated execution of a block of code as long as a condition is met. Common types of loops are for and while loops. A for loop iterates over a sequence of values, while a while loop continues as long as a specified condition remains true. For instance, a for loop in Python might look like this:\n
''', style: tutorialData.paragraphStyle),
                      const TextSpan(text: '''
for i in range(5):     
      print(i)
'''),
                    ])
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
