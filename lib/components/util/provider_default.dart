import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget blankError(error, stackTrace) {
  if (kDebugMode) {
    debugPrint('error: ${error.toString()}');
    debugPrint('stackTrace: ${stackTrace.toString()}');
  }
  return const BlankWidget();
}

Widget blankLoading() => const BlankWidget();

Widget genericError(error, stackTrace) {
  if (kDebugMode) {
    debugPrint('error: ${error.toString()}');
    debugPrint('stackTrace: ${stackTrace.toString()}');
  }
  return const BLError();
}

Widget genericLoading() {
  if (kDebugMode) {
    debugPrint('Loading ...');
  }
  return const BLLoading();
}
