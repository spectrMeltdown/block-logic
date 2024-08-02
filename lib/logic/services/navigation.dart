// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/navigation.g.dart';

@Riverpod()
class CustomNavigation extends _$CustomNavigation {
  @override
  CustomNavigation build() => CustomNavigation();

  void pop(BuildContext context, [String? result]) {
    Navigator.pop(context, result);
  }

  void push(BuildContext context, Widget route, {VoidCallback? onPop}) {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => route));
    Navigator.push(context,
            PageTransition(child: route, type: PageTransitionType.fade))
        .then((value) {
      if (onPop != null) onPop.call();
    });
  }

  void pushAndRemove(BuildContext context, Widget route) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => route),
      (route) => false, // Predicate to remove all previous routes
    );
  }

  void pushReplace(BuildContext context, Widget route) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => route));
  }
}
