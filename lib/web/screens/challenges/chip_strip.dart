import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChipStrip extends ConsumerWidget {
  final List<Widget> children;
  final GlobalKey btnKey;
  final void Function() onPressed;
  const ChipStrip({
    required this.children,
    required this.btnKey,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Flexible(
            child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          child: SpacedRow(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: children,
          ),
        )),
        const SizedBox(width: 10),
        BLAdminButton(
            key: btnKey,
            type: AdminBtnType.green,
            onPressed: onPressed,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ))
      ],
    );
  }
}
