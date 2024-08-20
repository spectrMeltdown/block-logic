import 'package:block_logic/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/responsive.g.dart';

@riverpod
class ResponsiveManager extends _$ResponsiveManager {
  @override
  void build() {}

  double getTextSize(double width) {
    if (width >= desktopMin) {
      return 16.0; // Desktop size
    } else if (width >= tabletMin) {
      return 15.0; // Tablet size
    } else {
      return 14.0; // Mobile size
    }
  }
}
