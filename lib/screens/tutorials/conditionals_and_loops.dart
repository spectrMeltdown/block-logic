import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text.dart';
import 'package:flutter/material.dart';

class ConditionalsAndLoops extends StatelessWidget {
  const ConditionalsAndLoops({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(children: [BLBackButton()]),
          Center(
            child: BLSmallTitle('Conditionals & Loops'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Conditionals allow programs to make decisions based on certain conditions. The most common conditional statement is if, which executes a block of code only if a specified condition is true. For example:\n\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
if temperature > 30:
          print("It's hot outside!")\n\n
'''),
                      TextSpan(text: '''
This code checks if the temperature is greater than 30 and prints a message if the condition is true.\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
Loops enable repeated execution of a block of code as long as a condition is met. Common types of loops are for and while loops. A for loop iterates over a sequence of values, while a while loop continues as long as a specified condition remains true. For instance, a for loop in Python might look like this:\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
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
