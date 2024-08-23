import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlChip extends ConsumerWidget {
  final void Function()? onDeleted;
  final Widget label;
  const BlChip({this.onDeleted, required this.label, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Chip(
      deleteIconColor: Colors.red,
      backgroundColor: Colors.teal,
      label: label,
      onDeleted: onDeleted,
    );
  }
}
