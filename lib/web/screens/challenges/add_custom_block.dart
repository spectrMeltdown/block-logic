import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/dart.dart';

class CustomBlockDialog extends ConsumerWidget {
  const CustomBlockDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = CodeController(
        text: 'class ExampleClass {\n\n}', // Initial code
        language: dart,
        analyzer: DartPadAnalyzer());
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      child: Center(
        child: Column(
          children: [
            const BLText('Describe the new object:'),
            CodeTheme(
              data: CodeThemeData(styles: monokaiSublimeTheme),
              child: SingleChildScrollView(
                child: CodeField(
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
