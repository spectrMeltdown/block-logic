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

class Variables extends ConsumerStatefulWidget {
  const Variables({super.key});

  @override
  ConsumerState<Variables> createState() => _VariablesScreenState();
}

class _VariablesScreenState extends ConsumerState<Variables> {
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
              'Introduction to \nVariables in Python',
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
                                text: 'A variable in programming is like a container where you can store a value. '
                                    'It has a name, and you can use that name to access or change the value later.\n\n',
                              ),
                              TextSpan(
                                text: '1. Creating a Variable:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   In Python, you create a variable simply by assigning a value to it using the ',
                              ),
                              TextSpan(
                                text: 'equals sign `=`.\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   Example:\n\n',
                              ),
                              TextSpan(
                                text: '   age = 25\n   name = "Alice"\n   price = 19.99\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '2. Variable Naming Rules:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   Variables must follow certain rules:\n'
                                    '   - They can only contain letters, numbers, and underscores ',
                              ),
                              TextSpan(
                                text: '(_).\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - They must start with a letter or an underscore ',
                              ),
                              TextSpan(
                                text: '(_).\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - They are case-sensitive (e.g., ',
                              ),
                              TextSpan(
                                text: 'age ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'and ',
                              ),
                              TextSpan(
                                text: 'Age ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'are different).\n\n',
                              ),
                              TextSpan(
                                text: '3. Changing Variable Values:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   Once you create a variable, you can change its value by assigning a new one.\n',
                              ),
                              const TextSpan(
                                text: '   Example:\n\n',
                              ),
                              TextSpan(
                                text: '   age = 30\n   name = "Bob"\n   price = 15.99\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '4. Dynamic Typing:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   Python is dynamically typed, meaning you don’t have to specify the type of variable. '
                                    'The type is inferred based on the value you assign.\n',
                              ),
                              const TextSpan(
                                text: '   Example:\n\n',
                              ),
                              TextSpan(
                                text: '   number = 10   # This is an integer\n   number = 3.14  # Now it’s a float\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '5. Multiple Assignments:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   Python allows you to assign values to multiple variables at once.\n',
                              ),
                              const TextSpan(
                                text: '   Example:\n\n',
                              ),
                              TextSpan(
                                text: '   x, y, z = 1, 2, 3\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   Now ',
                              ),
                              TextSpan(
                                text: 'x ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'is 1, ',
                              ),
                              TextSpan(
                                text: 'y ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'is 2, and ',
                              ),
                              TextSpan(
                                text: 'z ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'is 3.\n\n',
                              ),
                              TextSpan(
                                text: '6. Swapping Variable Values:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   You can swap the values of two variables in Python easily.\n',
                              ),
                              const TextSpan(
                                text: '   Example:\n\n',
                              ),
                              TextSpan(
                                text: '   a, b = 5, 10\n   a, b = b, a\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   After swapping, ',
                              ),
                              TextSpan(
                                text: 'a ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'is 10 and ',
                              ),
                              TextSpan(
                                text: 'b ',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: 'is 5.\n\n',
                              ),
                              TextSpan(
                                text: '7. Constants:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   Python doesn’t have built-in support for constants, but by convention, '
                                    'variables that should not change are written in uppercase letters.\n',
                              ),
                              const TextSpan(
                                text: '   Example:\n\n',
                              ),
                              TextSpan(
                                text: '   PI = 3.14159\n   GRAVITY = 9.8\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: 'That’s a basic overview of how variables work in Python. '
                                    'They are fundamental to programming and will be used constantly!',
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
