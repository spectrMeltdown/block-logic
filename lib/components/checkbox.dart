import 'package:block_logic/logic/services/ui.dart';
import 'package:flutter/material.dart';

class BLCheckbox extends StatefulWidget {
  const BLCheckbox({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  State<BLCheckbox> createState() => _BLCheckboxState();
}

class _BLCheckboxState extends State<BLCheckbox> {
  bool _isChecked = false;
  //bool _isTapped = false;
  late Color btnPressedColor;
  late Color btnColor;
  double _scale = 0;

  void _startAnimation() {
    setState(() {
      _scale = _scale == 1 ? 1.5 : 1.0;
    });
  }

  void _onTapUp(TapUpDetails tapUp) {
    setState(() {
      // _isTapped = false;
      _isChecked = !_isChecked;
    });
    _startAnimation();
    widget.onPressed?.call();
  }

  // void _onTapDown(TapDownDetails tapDown) {
  //   setState(() {
  //     // _isTapped = true;
  //   });
  // }

  // void _onTapCancel() {
  //   setState(() {
  //     // _isTapped = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onTapUp,
      //onTapDown: _onTapDown,
      //onTapCancel: _onTapCancel,
      child: Container(
          width: 25,
          height: 25,
          decoration: ShapeDecoration(
            gradient: RadialGradient(colors: [Colors.blueGrey[900]!, Colors.black87], radius: 1.5),
            shape: BeveledRectangleBorder(borderRadius: const BorderRadius.only(bottomRight: Radius.circular(7)), side: BorderSide(color: BLUI().getAppColor('lightblue'))),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _isChecked ? 1 : 0,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                margin: _isChecked ? const EdgeInsets.all(4) : const EdgeInsets.all(20),
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5)),
                  ),
                )),
          )),
    );
  }
}
