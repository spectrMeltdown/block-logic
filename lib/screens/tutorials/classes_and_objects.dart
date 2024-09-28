import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
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
    final nav = ref.read(customNavigationProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const BLText(
              'Introduction to Classes\nand Objects in Python',
              softWrap: true,
              color: Colors.white,
              bold: true,
              alignCenter: true,
              size: 25,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            child: BLRichText([
                              const TextSpan(
                                text: 'Classes and objects are fundamental concepts in object-oriented programming (OOP) that help organize code and model real-world entities.\n\n',
                              ),
                              TextSpan(
                                text: '1. What is a Class?\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - A class is a blueprint for creating objects. It defines a set of attributes and methods that the objects created from the class can have.\n',
                              ),
                              const TextSpan(
                                text: '   - Example of a class definition:\n',
                              ),
                              const TextSpan(
                                text: '     class ',
                              ),
                              TextSpan(
                                text: 'Dog:',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tdef __init__(self, name, age):\n',
                              ),
                              const TextSpan(
                                text: '     \t\tself.name = name\n',
                              ),
                              const TextSpan(
                                text: '     \t\tself.age = age\n\n',
                              ),
                              TextSpan(
                                text: '2. What is an Object?\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - An object is an instance of a class. It represents a specific entity that has the properties defined by the class.\n',
                              ),
                              const TextSpan(
                                text: '   - Example of creating an object:\n',
                              ),
                              const TextSpan(
                                text: '     my_dog = ',
                              ),
                              TextSpan(
                                text: 'Dog("Buddy", 5)',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' creates an object named my_dog with the name "Buddy" and age 5.\n\n',
                              ),
                              TextSpan(
                                text: '3. Methods in Classes:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - Methods are functions defined within a class that describe the behaviors of the objects.\n',
                              ),
                              const TextSpan(
                                text: '   - Example of a method:\n',
                              ),
                              const TextSpan(
                                text: '     def ',
                              ),
                              TextSpan(
                                text: 'bark(self):',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tprint("Woof!")\n\n',
                              ),
                              TextSpan(
                                text: '4. Conclusion:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Understanding classes and objects will enable you to implement object-oriented programming in Python, making your code more modular and organized.',
                                style: tutorialData.paragraphStyle.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BLButton(
              type: BtnType.red,
              paddingX: 100,
              onPressed: () => nav.pop(context),
              child: const BLText('Back'),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      )),
    );
  }
}
