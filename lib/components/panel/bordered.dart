import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';

class BLBorderedPanel extends StatelessWidget {
  final Widget child;
  final Color? overlayColor;
  final Color? color;
  const BLBorderedPanel(
      {required this.child, super.key, this.color, this.overlayColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: BLUI().getAppColor('grey'), width: 3),
          color: overlayColor ?? BLUI().getAppColor('darkblue'),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  const BoxShadow(color: Colors.black45),
                  BoxShadow(
                      color: color ?? BLUI().getAppColor('darkblue'),
                      spreadRadius: -5,
                      blurRadius: 20)
                ]),
            child: child));
  }
}
