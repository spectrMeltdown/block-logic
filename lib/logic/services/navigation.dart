// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/navigation.g.dart';

@riverpod
class CustomNavigation extends _$CustomNavigation {
  @override
  void build() {}

  void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  Future<Object?> push(
    BuildContext context,
    Widget route, {
    // VoidCallback? onPop,
    PageTransitionType transition = PageTransitionType.fade,
    Widget? childCurrent,
  }) {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => route));
    return Navigator.push<Object>(
      context,
      PageTransition(
        child: route,
        type: transition,
        curve: Curves.easeInOutCubic,
        childCurrent: childCurrent,
        // reverseDuration: null,
        // duration: Duration(milliseconds: transition != PageTransitionType.fade ? 300 : 300),
      ),
    );
    // .then((value) {
    //   if (onPop != null) onPop.call();
    // });
  }

  void pushAndRemove(BuildContext context, Widget route) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => route),
      (route) => false, // Predicate to remove all previous routes
    );
  }

  void pushReplace(BuildContext context, Widget route) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
  }
}
