// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/cupertino.dart';
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
  }) async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: barrierDismissable,
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final primaryCurve = CurvedAnimation(
            parent: animation,
            //     begin: const Offset(0, 1),
            //     end: const Offset(0, 0),
            //   ).animate(animation),
            //   child: child,
            // );
            curve: Curves.easeInOut,
            reverseCurve: Curves.easeInOut,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(primaryCurve),
            child: child,
          );
          // return SlideTransition(
          //   position: Tween<Offset>(
        },
        pageBuilder: (context, animation1, animation2) {
          return dialog;
        });
  }
}
