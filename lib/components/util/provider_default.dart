import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget blankError(error, stackTrace) {
  if (kDebugMode) {
    dPrint('error: ${error.toString()}');
    dPrint('stackTrace: ${stackTrace.toString()}');
  }
  return const BlankWidget();
}

Widget blankLoading() => const BlankWidget();

Widget genericError(error, stackTrace) {
  if (kDebugMode) {
    dPrint('error: ${error.toString()}');
    dPrint('stackTrace: ${stackTrace.toString()}');
  }
  return const BLError();
}

Widget genericLoading({LoadingType type = LoadingType.fill}) {
  if (kDebugMode) {
    dPrint('Loading ...');
  }
  return BLLoading(
    type: type,
  );
}
