import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorAddBtn extends ConsumerWidget {
  final CodeBlockType type;
  final void Function(CodeBlockType) addCustom;
  const BlockSelectorAddBtn({
    required this.type,
    required this.addCustom,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case CodeBlockType.objects:
        return BLAdminButton(type: AdminBtnType.teal, child: const BLText('Add object'), onPressed: () => addCustom(CodeBlockType.objects));
      case CodeBlockType.functions:
        return BLAdminButton(type: AdminBtnType.teal, child: const BLText('Add function'), onPressed: () => addCustom(CodeBlockType.functions));
      case CodeBlockType.variables:
        return BLAdminButton(type: AdminBtnType.teal, child: const BLText('Add variable'), onPressed: () => addCustom(CodeBlockType.variables));
      case CodeBlockType.literals:
        return BLAdminButton(type: AdminBtnType.teal, child: const BLText('Add literal'), onPressed: () => addCustom(CodeBlockType.literals));
      default:
        return const SizedBox.shrink();
    }
  }
}
