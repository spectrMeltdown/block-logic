import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';

class Functions extends StatelessWidget {
  const Functions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(children: [BLBackButton()]),
          Center(
            child: BLSmallTitle('Functions'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
A function is a reusable block of code designed to perform a particular task. Functions can take input values (arguments), process them, and return an output.  \n\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
For example, a function to add two numbers in Python might look like this: \n\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
def add(a, b):     
     return a + b
'''),
                      TextSpan(text: '''
You can call this function with specific values, like add(2, 3), to get the result 5.
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
