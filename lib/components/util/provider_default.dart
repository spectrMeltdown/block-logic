import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/error.dart';
import 'package:flutter/material.dart';

Widget genericError(error, stackTrace) {
  debugPrint('error: ${error.toString()}');
  debugPrint('stackTrace: ${stackTrace.toString()}');
  return const BLError();
}

Widget genericLoading() => const BLLoading();
