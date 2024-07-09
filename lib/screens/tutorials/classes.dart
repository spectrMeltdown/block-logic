import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text.dart';
import 'package:flutter/material.dart';

class Classes extends StatelessWidget {
  const Classes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(children: [BLBackButton()]),
          Center(
            child: BLSmallTitle('Classes'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Classes provide a way to create custom data types by bundling data and methods (functions) that operate on that data. A class defines the structure and behavior of the objects created from it. For instance, you might define a Dog class to represent dogs in a program:\n\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
class Dog:     def __init__(self, name, age):         self.name = name         self.age = age      def bark(self):         print("Woof!")
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
