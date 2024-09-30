import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConditionalsAndLoops extends ConsumerStatefulWidget {
  const ConditionalsAndLoops({super.key});

  @override
  ConsumerState<ConditionalsAndLoops> createState() => _ConditionalsAndLoopsState();
}

class _ConditionalsAndLoopsState extends ConsumerState<ConditionalsAndLoops> {
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
              'Introduction to Conditionals\nand Loops in Python',
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
                                text: 'Conditionals and loops are fundamental concepts in programming that allow you to control the flow of your code.\n\n',
                              ),
                              TextSpan(
                                text: '1. Conditionals:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - Conditionals are used to execute different blocks of code based on certain conditions.\n',
                              ),
                              const TextSpan(
                                text: '   - The most common conditional statement is the ',
                              ),
                              TextSpan(
                                text: 'if statement',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ':\n     Example:\n',
                              ),
                              const TextSpan(
                                text: '     if ',
                              ),
                              TextSpan(
                                text: 'x > 10:',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tprint("x is greater than 10")\n\n',
                              ),
                              const TextSpan(
                                text: '   - You can also use ',
                              ),
                              TextSpan(
                                text: 'else',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' and ',
                              ),
                              TextSpan(
                                text: 'elif',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' to handle multiple conditions:\n     Example:\n',
                              ),
                              const TextSpan(
                                text: '     if ',
                              ),
                              TextSpan(
                                text: 'x > 10:',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tprint("x is greater than 10")\n',
                              ),
                              const TextSpan(
                                text: '     elif ',
                              ),
                              TextSpan(
                                text: 'x == 10:',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tprint("x is equal to 10")\n',
                              ),
                              const TextSpan(
                                text: '     else:\n     \tprint("x is less than 10")\n\n',
                              ),
                              TextSpan(
                                text: '2. Loops:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   - Loops allow you to execute a block of code repeatedly.\n',
                              ),
                              const TextSpan(
                                text: '   - The most common loops in Python are the ',
                              ),
                              TextSpan(
                                text: 'for loop',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ' and the ',
                              ),
                              TextSpan(
                                text: 'while loop',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: ':\n     Example of a for loop:\n',
                              ),
                              const TextSpan(
                                text: '     for ',
                              ),
                              TextSpan(
                                text: 'i in range(5):',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tprint(i)\n\n',
                              ),
                              const TextSpan(
                                text: '   - Example of a while loop:\n',
                              ),
                              const TextSpan(
                                text: '     while ',
                              ),
                              TextSpan(
                                text: 'x < 5:',
                                style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                              ),
                              const TextSpan(
                                text: '\n     \tprint(x)\n     \tx += 1\n\n',
                              ),
                              TextSpan(
                                text: '3. Conclusion:\n',
                                style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '   - Mastering conditionals and loops will allow you to create dynamic and powerful programs in Python.',
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
