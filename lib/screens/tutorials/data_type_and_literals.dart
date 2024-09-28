import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/card/card.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataTypesAndLiterals extends ConsumerWidget {
  const DataTypesAndLiterals({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'Introduction to Data Types \nand Literals in Python',
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
                                text: 'In programming, a "data type" is the kind of information a value can hold. '
                                    'For example, numbers or words are different kinds of data.\n\n',
                              ),
                              TextSpan(
                                text: '1. Numbers (Numeric Types):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'int',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Whole numbers, like 1, 42, or -5.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'age = 25\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'float',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Decimal numbers, like 3.14 or -0.001.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'price = 19.99\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'complex',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Numbers with a real and imaginary part, like 3 + 4j.\n'
                                    '     You won’t use these much as a beginner!\n\n',
                              ),
                              TextSpan(
                                text: '2. Words and Text (String):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'str',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Used for storing text.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'name = "Alice"',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' or ',
                              ),
                              TextSpan(
                                text: 'message = \'Hello\'\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '3. Lists (Collections of Items):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'list',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': A list stores multiple values together.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'fruits = ["apple", "banana", "cherry"]\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '     Lists can be changed after you create them.\n\n',
                              ),
                              TextSpan(
                                text: '4. Fixed Collections (Tuples):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'tuple',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Like a list, but you can’t change the values once created.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'coordinates = (10, 20)\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '5. Key-Value Pairs (Dictionaries):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'dict',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Stores data as key-value pairs.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'person = {"name": "Alice", "age": 25}\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '6. Sets (Unique Items):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'set',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': A collection of unique items.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'unique_numbers = {1, 2, 3}\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '     Sets automatically remove duplicates!\n\n',
                              ),
                              TextSpan(
                                text: '7. True or False (Boolean):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'bool',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': This data type can only be True or False.\n     Example: ',
                              ),
                              TextSpan(
                                text: 'is_sunny = True',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' or ',
                              ),
                              TextSpan(
                                text: 'has_license = False\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '8. Empty Value (None):\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - ',
                              ),
                              TextSpan(
                                text: 'None',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ': Represents nothing or no value. It’s like saying "empty".\n     Example: ',
                              ),
                              TextSpan(
                                text: 'result = None\n\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: 'Literals in Python:\n\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: 'Literals are fixed values written directly in the code. Here are some examples:\n\n',
                              ),
                              const TextSpan(
                                text: '   - String literals: ',
                              ),
                              TextSpan(
                                text: '"Hello", "World"\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - Integer literals: ',
                              ),
                              TextSpan(
                                text: '10, 42\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - Floating-point literals: ',
                              ),
                              TextSpan(
                                text: '3.14, 2.0\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - Boolean literals: ',
                              ),
                              TextSpan(
                                text: 'True, False\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '   - Special literal: ',
                              ),
                              TextSpan(
                                text: 'None\n',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              TextSpan(
                                text: '\nThat’s it! These are the basic building blocks you’ll need to understand Python data.',
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
