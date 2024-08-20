import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataTypesAndLiterals extends ConsumerStatefulWidget {
  const DataTypesAndLiterals({super.key});

  @override
  ConsumerState<DataTypesAndLiterals> createState() =>
      _DataTypesAndLiteralsState();
}

class _DataTypesAndLiteralsState extends ConsumerState<DataTypesAndLiterals> {
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
            child: BLSmallTitle('Data Types & Literals'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLRichText([
                      TextSpan(text: '''
Data types define the kind of data a variable can hold. Common data types include integers (whole numbers), floats (decimal numbers), strings (text), and booleans (true/false values).  \n\n
''', style: tutorialData.paragraphStyle),
                      TextSpan(text: '''
Literals are the actual values assigned to variables, written directly in the code. For instance, in the statement x = 10, the number 10 is an integer literal. Understanding data types is crucial for performing appropriate operations on data.
''', style: tutorialData.paragraphStyle)
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
