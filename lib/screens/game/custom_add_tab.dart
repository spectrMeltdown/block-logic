import 'package:block_logic/screens/game/custom_tab.dart';
import 'package:flutter/material.dart';

class AddTab extends StatelessWidget {
  const AddTab(this.callback, {super.key});
  final VoidCallback callback;
  void onTapUp(TapUpDetails tap) {
    callback.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapUp: onTapUp,
        child: const CustomTab(
          title: '+',
          isSelected: false,
        ));
  }
}
