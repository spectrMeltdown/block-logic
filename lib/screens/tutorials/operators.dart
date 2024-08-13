import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Operators extends ConsumerStatefulWidget {
  const Operators({super.key});

  @override
  ConsumerState<Operators> createState() => _OperatorsState();
}

class _OperatorsState extends ConsumerState<Operators> {
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
            child: BLSmallTitle('Operators'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Operators are special symbols that carry out operations on operands (variables and values). Common types of operators include:\n
• Arithmetic operators: Perform basic mathematical operations (e.g., +, -, *, /).\n
• Comparison operators: Compare two values and return a boolean result (e.g., ==, !=, <, >).\n
• Logical operators: Combine multiple boolean expressions (e.g., and, or, not). For example, the expression 5 + 3 uses the arithmetic operator + to add two numbers.
''', style: tutorialData.paragraphStyle),
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
