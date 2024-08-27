import 'package:flutter/material.dart';

enum AdminBtnType {
  green,
  red,
  teal,
  orange,
  grey,
}

class BLAdminButton extends StatefulWidget {
  final AdminBtnType type;
  final Widget child;
  final VoidCallback onPressed;
  final double? paddingX;
  final double? paddingY;
  final bool disabled;
  const BLAdminButton({
    super.key,
    required this.type,
    required this.child,
    required this.onPressed,
    this.paddingX,
    this.paddingY,
    this.disabled = false,
  });

  @override
  State<BLAdminButton> createState() => _BLAdminButtonState();
}

class _BLAdminButtonState extends State<BLAdminButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return getBgColor(); // Change color when hovered
              }
              return getBgColor().withOpacity(0.9); // Default background color
            },
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
              horizontal: widget.paddingX ?? 15,
              vertical: widget.paddingY ?? 13,
            ),
          ),
        ),
        onPressed: () {
          if (widget.disabled == false) {
            widget.onPressed.call();
          } else {
            debugPrint('Button is disabled');
          }
        },
        child: widget.child);
  }

  Color getBgColor() {
    switch (widget.type) {
      case AdminBtnType.green:
        return Colors.green;
      case AdminBtnType.red:
        return Colors.red;
      case AdminBtnType.orange:
        return Colors.orange;
      case AdminBtnType.grey:
        return Colors.grey;
      case AdminBtnType.teal:
        return Colors.teal;
    }
  }
}
