import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Variables extends ConsumerStatefulWidget {
  const Variables({super.key});

  @override
  ConsumerState<Variables> createState() => _VariablesScreenState();
}

class _VariablesScreenState extends ConsumerState<Variables> {
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
            child: BLSmallTitle('Variables'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Variables act as containers for storing data values. Each variable has a name, and it can be used to store information that can be referenced and manipulated in a program. \n\n
''', style: tutorialData.paragraphStyle),
                      const TextSpan(text: '''
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
