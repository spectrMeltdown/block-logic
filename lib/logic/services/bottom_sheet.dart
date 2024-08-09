// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/bottom_sheet.g.dart';

// had a problem with riverpod, so I just made this a class even though it doesn't hold state
@riverpod
class BottomSheetServiceState extends _$BottomSheetServiceState {
  @override
  BottomSheet build() => BottomSheet();
}

class BottomSheet {
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
