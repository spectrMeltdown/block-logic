import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:flutter/material.dart';

Widget genericError(error, stackTrace) {
  debugPrint('generic error called');
  debugPrint(error.toString());
  return const BLError();
}

Widget genericLoading() {
  return const BLLoading();
}

Widget blankError(error, stackTrace) => const BlankWidget();

Widget blankLoading() => const BlankWidget();
