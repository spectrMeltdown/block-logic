import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';

class DataTypesAndLiterals extends StatelessWidget {
  const DataTypesAndLiterals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          Row(children: [BLBackButton()]),
          Center(
            child: BLSmallTitle('Data Types & Literals'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Data types define the kind of data a variable can hold. Common data types include integers (whole numbers), floats (decimal numbers), strings (text), and booleans (true/false values).  \n\n
''', style: TextStyle(color: Colors.white)),
                      TextSpan(text: '''
Literals are the actual values assigned to variables, written directly in the code. For instance, in the statement x = 10, the number 10 is an integer literal. Understanding data types is crucial for performing appropriate operations on data.
''', style: TextStyle(color: Colors.white))
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
