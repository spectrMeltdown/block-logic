import 'package:flutter/widgets.dart';

/// For placeholder widgets with zero size
class BlankWidget extends StatelessWidget {
  const BlankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
