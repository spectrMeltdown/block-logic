import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Functions extends ConsumerStatefulWidget {
  const Functions({super.key});

  @override
  ConsumerState<Functions> createState() => _FunctionsState();
}

class _FunctionsState extends ConsumerState<Functions> {
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
            child: BLSmallTitle('Functions'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
A function is a reusable block of code designed to perform a particular task. Functions can take input values (arguments), process them, and return an output.  \n\n
''', style: tutorialData.paragraphStyle),
                      TextSpan(text: '''
For example, a function to add two numbers in Python might look like this: \n\n
''', style: tutorialData.paragraphStyle),
                      const TextSpan(text: '''
def add(a, b):     
     return a + b
'''),
                      TextSpan(text: '''
You can call this function with specific values, like add(2, 3), to get the result 5.
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
