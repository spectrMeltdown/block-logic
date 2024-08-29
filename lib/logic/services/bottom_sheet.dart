// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/bottom_sheet.g.dart';

@riverpod
class BottomSheetService extends _$BottomSheetService {
  @override
  void build() {}

  Future<Object> show(
    BuildContext context,
    Widget bottomSheet, {
    bool enableDrag = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
  }) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      builder: (context) => bottomSheet,
    );
  }
}
