// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/dialog.g.dart';

@riverpod
class DialogService extends _$DialogService {
  @override
  void build() {}
  Future<Object?> show(
    BuildContext context,
    Widget dialog, {
    bool barrierDismissable = false,
    Object? returnType,
  }) async {
    if (kIsWeb) {
      return showDialog(context: context, builder: (context) => dialog);
    }
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissable,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return dialog;
      },
    );
  }
}
