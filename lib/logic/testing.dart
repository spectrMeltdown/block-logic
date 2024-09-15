library testing;

import 'package:flutter/material.dart';

void clearConsole() {
  debugPrint('\x1B[2J\x1B[0;0H'); // Clears terminal on some systems that support ANSI escape
}
