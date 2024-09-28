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

class Operators extends ConsumerStatefulWidget {
  const Operators({super.key});

  @override
  ConsumerState<Operators> createState() => _OperatorsState();
}

class _OperatorsState extends ConsumerState<Operators> {
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
              'Introduction to\nOperators in Python',
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
                                text: 'Operators are special symbols in Python that perform operations on variables and values. '
                                    'They can be used for mathematical calculations, comparisons, logical operations, and more.\n\n',
                              ),
                              TextSpan(
                                text: '1. Types of Operators:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - Python has various types of operators, including:\n',
                              ),
                              const TextSpan(
                                text: '     - ',
                              ),
                              TextSpan(
                                text: 'Arithmetic Operators',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Used for basic math operations like addition, subtraction, etc.\n'
                                    '     Example: ',
                              ),
                              TextSpan(
                                text: 'result = 10 + 5',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' (result will be 15)\n',
                              ),
                              const TextSpan(
                                text: '     - ',
                              ),
                              TextSpan(
                                text: 'Comparison Operators',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Used to compare two values.\n'
                                    '     Example: ',
                              ),
                              TextSpan(
                                text: 'x == y',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' checks if x is equal to y.\n',
                              ),
                              const TextSpan(
                                text: '     - ',
                              ),
                              TextSpan(
                                text: 'Logical Operators',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Used to combine conditional statements.\n'
                                    '     Example: ',
                              ),
                              TextSpan(
                                text: 'if (x > 5 and y < 10):',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' checks if both conditions are true.\n',
                              ),
                              const TextSpan(
                                text: '     - ',
                              ),
                              TextSpan(
                                text: 'Bitwise Operators',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Operate on bits and perform bit-by-bit operations.\n'
                                    '     Example: ',
                              ),
                              TextSpan(
                                text: 'result = x & y',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' performs a bitwise AND operation.\n',
                              ),
                              const TextSpan(
                                text: '     - ',
                              ),
                              TextSpan(
                                text: 'Assignment Operators',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Used to assign values to variables.\n'
                                    '     Example: ',
                              ),
                              TextSpan(
                                text: 'x = 10',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' assigns 10 to x.\n',
                              ),
                              TextSpan(
                                text: '2. Importance of Operators:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - Understanding operators is essential for performing calculations and controlling the flow of your code.\n\n',
                              ),
                              TextSpan(
                                text: '3. Conclusion:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Mastering operators will enhance your ability to write effective Python programs.',
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
