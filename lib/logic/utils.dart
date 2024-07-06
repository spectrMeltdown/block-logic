import "dart:math";
import 'package:http/http.dart' as http;
import "package:block_logic/components/dialog.dart";
import "package:block_logic/logic/toast.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

/// General redundant code throughout the app
abstract class Utils {
  /// a custom assert function for functions, for development only
  static void assertFunc(VoidCallback func) {
    assert(() {
      func.call();
      return true;
    }());
  }

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

Future<bool> checkInternetConnection() async {
  try {
    /// try connecting to google
    final response = await http.get(Uri.parse('http://google.com'));

    /// check if connection was success. If failed, not internet
    return response.statusCode == 200;
  } catch (e) {
    /// if failed, not internet
    return false;
  }
}

String? fireErrors(BuildContext context, FirebaseException e) {
  dismissAllToast();
  switch (e.code) {
    case 'network-request-failed':
      const String error = 'Network Problem!';
      notifyDialog(context, title: 'Error', label: error);
      return error;
    case 'invalid-credential':
      const String error = 'Incorrect credentials';
      notifyDialog(context, title: 'Error', label: error);
      return error;
    case 'invalid-email':
      const String error = 'Incorrect email.';
      notifyDialog(context, title: 'Error', label: error);
      return error;
    case 'email-already-in-use':
      const String error = 'Account already exists!';
      notifyDialog(context, title: 'Error', label: error);
      return error;
    case 'requires-recent-login':
      // TODO: display reauth overlay
      return null;
    default:
      if (kDebugMode) {
        notifyDialog(context, title: e.code, label: e.message);
      }
      return null;
  }
}
