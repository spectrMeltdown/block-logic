import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/data_type.dart';
import 'package:block_logic/logic/game/py_literal.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBlockDialog extends ConsumerStatefulWidget {
  final CodeBlockType type;
  final List<GameBlockData> customBlocks;
  const CustomBlockDialog(this.type, {required this.customBlocks, super.key});

  @override
  ConsumerState<CustomBlockDialog> createState() => _CustomBlockDialogState();
}

class _CustomBlockDialogState extends ConsumerState<CustomBlockDialog> {
  late final CustomNavigation nav;
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  Widget msg = const BlankWidget();
  PyDataType? selectedDataType;
  bool processing = false;

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  void updateMsg(String text) {
    setState(() {
      msg = BLText(
        text,
        color: Colors.red,
        alignCenter: true,
      );
    });
  }

  Future<void> saveBlock() async {
    if (processing) return;
    toggleProcessing();
    setState(() {
      msg = SizedBox.shrink();
    });
    if (widget.type == CodeBlockType.literals) {
      if (selectedDataType == null) {
        updateMsg('Select a data type.');
        toggleProcessing();
        return;
      }
    }
    if (formKey.currentState!.validate()) {
      final input = codeController.text.trim();
      PyLiteral? literal;

      /// assign literal if meet requirements
      if (selectedDataType != null) {
        switch (selectedDataType) {
          case PyDataType.string_:
            literal = PyLiteral.string(input);
            break;
          case PyDataType.boolean_:
            if (bool.tryParse(input) != null) {
              literal = PyLiteral.boolean(input as bool);
            }
            break;
          case PyDataType.number_:
            if (int.tryParse(input) != null) {
              literal = PyLiteral.number(intNum: int.parse(input));
            } else if (double.tryParse(input) != null) {
              literal = PyLiteral.number(doubleNum: double.parse(input));
            }
            break;
          case PyDataType.none_:
            if (input.contains('none')) {
              literal = PyLiteral.none();
            }
            break;
          case PyDataType.array:
            RegExp exp = RegExp(r'[\[\],]');
            if (exp.hasMatch(input)) {
              literal = PyLiteral.array(input);
            }
            break;
          default:
        }
      }

      // data to return
      late GameBlockData data;

      // assign data if meet requirements
      switch (widget.type) {
        case CodeBlockType.objects:
          // if exists customBlocks does not contain the input
          if (widget.customBlocks.isNotEmpty || !widget.customBlocks.any((e) => e.name.trim().toUpperCase() == input.trim().toUpperCase())) {
            data = GameBlockData.createObject(name: input);
          } else {
            updateMsg('An object with this name already exists.');
            toggleProcessing();
            return;
          }

          break;
        case CodeBlockType.functions:
          if (widget.customBlocks.isNotEmpty || !widget.customBlocks.any((e) => e.name.trim().toUpperCase() == input.trim().toUpperCase())) {
            data = GameBlockData.createFunction(name: input);
          } else {
            updateMsg('A function with this name already exists.');
            toggleProcessing();
            return;
          }

          break;
        case CodeBlockType.variables:
          data = GameBlockData.createVariable(name: input, value: PyLiteral.none());
          break;
        case CodeBlockType.literals:
          if (literal == null) {
            updateMsg('Unrecognized input! (must have proper format)');
            toggleProcessing();
            return;
          }
          data = GameBlockData.createLiteral(literal: literal);
          break;
        default:
          throw ('Invalid Type!');
      }
      data = data.copyWith(inSelectorCount: 1);
      nav.pop(context, data);
    }
    toggleProcessing();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BLText('Define the new block:'),
            const SizedBox(height: 15),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BLTextBox(
                  controller: codeController,
                  onFieldSubmitted: (p0) => saveBlock(),
                  labelText: 'Code ...',
                  validator: (code) {
                    if (code == null || code.isEmpty) {
                      return 'Cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
            ),
            if (widget.type == CodeBlockType.literals) const SizedBox(height: 15),
            if (widget.type == CodeBlockType.literals)
              DropdownButton<PyDataType>(
                hint: const BLText('(Select data type)'),
                value: selectedDataType,
                items: List.generate(PyDataType.values.length, (i) {
                  return DropdownMenuItem(
                    value: PyDataType.values[i],
                    child: BLText(PyDataType.values[i].name.replaceFirst('_', '')),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedDataType = value;
                    });
                  }
                },
              ),
            const SizedBox(height: 20),
            msg,
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BLAdminButton(
                  type: processing ? AdminBtnType.grey : AdminBtnType.green,
                  child: const BLText('Save'),
                  onPressed: () => saveBlock(),
                ),
                const SizedBox(width: 15),
                BLAdminButton(
                  type: AdminBtnType.red,
                  child: const BLText('Cancel'),
                  onPressed: () => nav.pop(context),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
