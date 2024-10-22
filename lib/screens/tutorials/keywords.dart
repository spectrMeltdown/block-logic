import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/tutorials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Keywords extends ConsumerStatefulWidget {
  const Keywords({super.key});

  @override
  ConsumerState<Keywords> createState() => _KeywordsScreenState();
}

class _KeywordsScreenState extends ConsumerState<Keywords> {
  @override
  Widget build(BuildContext context) {
    final tutorialData = ref.read(tutorialDataProvider);
    final nav = ref.read(customNavigationProvider.notifier);
    final scrollController = ScrollController();
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
              'Introduction to\nKeywords in Python',
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
                    child: Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: BLRichText([
                                const TextSpan(
                                  text: 'Keywords are reserved words in Python that have special meaning and cannot be used for anything other than their intended purpose. '
                                      'They help define the syntax and structure of the code.\n\n',
                                ),
                                TextSpan(
                                  text: '1. List of Keywords:\n',
                                  style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: '   - Python has a set of keywords that you need to know. Here are some of the most common ones:\n',
                                ),
                                const TextSpan(
                                  text: '     - ',
                                ),
                                TextSpan(
                                  text: 'False',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'None',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'True',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'and',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'or',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'if',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'elif',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'else',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'for',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'while',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'break',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'continue',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'def',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'return',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'import',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'from',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'as',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'class',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'try',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'except',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'finally',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'with',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'assert',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'async',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'await',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'nonlocal',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ', ',
                                ),
                                TextSpan(
                                  text: 'global',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ' and more.\n\n',
                                ),
                                TextSpan(
                                  text: '2. Importance of Keywords:\n',
                                  style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: '   - Keywords help define the structure of your Python code. '
                                      'Understanding them is essential for writing valid Python programs.\n\n',
                                ),
                                TextSpan(
                                  text: '3. Using Keywords:\n',
                                  style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text: '   - Remember, you cannot use keywords as variable names or function names.\n'
                                      '     Example: Using ',
                                ),
                                TextSpan(
                                  text: 'def',
                                  style: tutorialData.paragraphStyle.copyWith(color: Colors.lightBlue.shade200),
                                ),
                                const TextSpan(
                                  text: ' as a variable name will cause an error.\n\n',
                                ),
                                TextSpan(
                                  text: '4. Conclusion:\n',
                                  style: tutorialData.paragraphStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '   - Mastering keywords is a crucial step in becoming proficient in Python programming.',
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
