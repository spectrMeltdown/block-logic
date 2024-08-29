import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockSelectorAddBtn extends ConsumerWidget {
  final CodeBlockType type;
  final void Function() addObj;
  const BlockSelectorAddBtn({
    required this.type,
    required this.addObj,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case CodeBlockType.objects:
        return BLAdminButton(type: AdminBtnType.teal, child: const BLText('Add'), onPressed: () => addObj);
      default:
        return const SizedBox.shrink();
    }
  }
}
