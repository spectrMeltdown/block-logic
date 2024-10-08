import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Connection to MethodChannel, for native Android services
class AppMonitor {
  static const platform = MethodChannel('com.uncaughtexception.blocklogic/monitor');

  static Future<bool> isAppRunning() async {
    try {
      final bool isRunning = await platform.invokeMethod('isAppRunning');
      return isRunning;
    } catch (e) {
      // debugPrint('Error checking app status: $e');
      return false;
    }
  }
}
