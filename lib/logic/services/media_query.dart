// ignore_for_file: avoid_build_context_in_providers
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/media_query.g.dart';

@riverpod
class BLMediaQuery extends _$BLMediaQuery {
  @override
  BLMediaQuery build() {
    return BLMediaQuery();
  }

  /// current screen width. Must be called inside a context.
  double screenW(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// current screen height. Must be called inside a context.
  double screenH(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
