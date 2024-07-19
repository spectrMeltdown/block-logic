import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// General redundant code throughout the app
abstract class Utils {
  /// a custom assert function for functions, for development only
  void assertFunc(VoidCallback func) {
    assert(() {
      func.call();
      return true;
    }());
  }

  /// to copy to clipboard
  void copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

  TextTheme textTheme(
    BuildContext context,
  ) {
    return Theme.of(context).textTheme;
  }
}
