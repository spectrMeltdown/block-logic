import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';

class Variables extends StatefulWidget {
  const Variables({super.key});

  @override
  State<Variables> createState() => _VariablesScreenState();
}

class _VariablesScreenState extends State<Variables> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(children: [BLBackButton()]),
          Center(
            child: BLSmallTitle('Variables'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Variables act as containers for storing data values. Each variable has a name, and it can be used to store information that can be referenced and manipulated in a program. \n\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
For example, in Python, you might write age = 25 to create a variable named age and assign it the value of 25. Variables make it easier to manage and update data within a program.
''')
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
