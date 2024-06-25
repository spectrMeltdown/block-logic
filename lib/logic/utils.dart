import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/services.dart";

/// For placeholder widgets with zero size
const Widget blankWidget = SizedBox.shrink();

/// General redundant code throughout the app
abstract class Utils {
  /// current screen width. Must be called inside a context.
  static double screenW(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// current screen height. Must be called inside a context.
  static double screenH(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// to copy to clipboard
  static void copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

  static TextTheme textTheme(
    BuildContext context,
  ) {
    return Theme.of(context).textTheme;
  }

  static void pop(BuildContext context, [String? result]) {
    Navigator.pop(context, result);
  }

  static void push(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  static void pushAndRemove(BuildContext context, Widget route) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => route),
      (route) => false, // Predicate to remove all previous routes
    );
  }

  static void pushReplace(BuildContext context, Widget route) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
  }

  static int oldRandNum = 0;

  static int getRandomInt() {
    final random = Random();
    int randNum = random.nextInt(100000);
    if (oldRandNum == randNum) {
      randNum = random.nextInt(100000);
      oldRandNum = randNum;
    }
    return randNum;
  }
}
