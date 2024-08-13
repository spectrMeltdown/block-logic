import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassesAndObjects extends ConsumerStatefulWidget {
  const ClassesAndObjects({super.key});

  @override
  ConsumerState<ClassesAndObjects> createState() => _ClassesAndObjectsState();
}

class _ClassesAndObjectsState extends ConsumerState<ClassesAndObjects> {
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
            child: BLSmallTitle('Classes & Objects'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BLTextSpan([
                      TextSpan(text: '''
Classes provide a way to create custom data types by bundling data and methods (functions) that operate on that data. \n\nA class defines the structure and behavior of the objects created from it. For instance, you might define a Dog class to represent dogs in a program:\n\n
''', style: tutorialData.paragraphStyle),
                      const TextSpan(text: '''
class Dog:    def __init__(self, name, age):        self.name = name        self.age = age    def bark(self):        print("Woof!")
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
