import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: BLBackButton(),
            ),
            const Center(
              child: BLSmallTitle('Keywords'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BLRichText([
                        TextSpan(text: '''
            Keywords. \n\n
            ''', style: tutorialData.paragraphStyle),
                        const TextSpan(text: '''
            
            ''')
                      ])
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
