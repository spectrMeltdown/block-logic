import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/dart.dart';

class CustomBlockDialog extends ConsumerWidget {
  const CustomBlockDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variableNameController = TextEditingController();
    final controller = CodeController(
        text: getInitText(), // Initial code
        language: dart,
        analyzer: DartPadAnalyzer());
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      child: Center(
        child: Builder(builder: (context) {
          switch (type) {
            case CodeBlockType.objects:
              return Column(
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
              );
            case CodeBlockType.literals:
              return Column(
                children: [
                  const BLText('Choose a literal:'),
                  Row(
                    children: [DropdownButton(items: const [], onChanged: (newValue) {})],
                  )
                ],
              );
            case CodeBlockType.variables:
              return Column(
                children: [
                  const BLText('Create your variable:'),
                  Row(
                    children: [
                      const BLText('Name'),
                      BLTextBox(
                        controller: variableNameController,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[\w]*$'))],
                      )
                    ],
                  ),
                  Row(
                    children: [const BLText('Value'), DropdownButton(items: const [], onChanged: (newValue) {})],
                  ),
                ],
              );
            default:
              return const BLText('Unsupported block type.');
          }
        }),
      ),
    ));
  }

  getInitText() {
    switch (type) {
      case CodeBlockType.objects:
        return 'class {\n\n}';
      default:
        return 'Error getting type';
    }
  }
}
