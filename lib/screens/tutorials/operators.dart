import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text.dart';
import 'package:flutter/material.dart';

class Operators extends StatelessWidget {
  const Operators({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(children: [BLBackButton()]),
          Center(
            child: BLSmallTitle('Operators'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Operators are special symbols that carry out operations on operands (variables and values). Common types of operators include:\n
• Arithmetic operators: Perform basic mathematical operations (e.g., +, -, *, /).\n
• Comparison operators: Compare two values and return a boolean result (e.g., ==, !=, <, >).\n
• Logical operators: Combine multiple boolean expressions (e.g., and, or, not). For example, the expression 5 + 3 uses the arithmetic operator + to add two numbers.
''', style: TextStyle(color: Colors.white)),
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
