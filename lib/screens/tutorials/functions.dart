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

class Functions extends ConsumerStatefulWidget {
  const Functions({super.key});

  @override
  ConsumerState<Functions> createState() => _FunctionsState();
}

class _FunctionsState extends ConsumerState<Functions> {
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
              'Introduction to\nFunctions in Python',
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
                              TextSpan(
                                text: 'Functions are blocks of reusable code that perform a specific task. '
                                    'They help organize and structure your program.\n\n',
                              ),
                              TextSpan(
                                text: '1. Defining a Function:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Use the keyword ',
                              ),
                              TextSpan(
                                text: 'def',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: ' to define a function.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'def greet():\n    print("Hello, World!")\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '2. Calling a Function:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - To execute a function, use its name followed by parentheses.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'greet()\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '3. Function Parameters:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - You can pass data to functions using parameters.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'def add(a, b):\n    return a + b\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '4. Return Statement:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Use ',
                              ),
                              TextSpan(
                                text: 'return',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: ' to send back a value from a function.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'result = add(5, 10)\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '5. Default Parameters:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - You can set default values for parameters.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'def greet(name="Guest"):\n    print("Hello, " + name)\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '6. Keyword Arguments:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - You can pass arguments by keyword instead of position.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'greet(name="Alice")\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '7. Variable-length Arguments:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Use *args for non-keyword and **kwargs for keyword arguments.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'def add_numbers(*args):\n    return sum(args)\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '8. Lambda Functions:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Short, anonymous functions defined with the lambda keyword.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'multiply = lambda x, y: x * y\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: 'In conclusion, functions are essential for writing clean and efficient code in Python.',
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
