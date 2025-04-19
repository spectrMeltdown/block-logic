import 'package:block_logic/logic/dev.dart';
import 'package:flutter/material.dart';

enum AdminBtnType {
  green,
  red,
  teal,
  orange,
  grey,
  blue,
}

class BLAdminButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return getBgColor(type); // Change color when hovered
              }
              return getBgColor(type).withValues(alpha: 0.9); // Default background color
            },
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
              horizontal: paddingX ?? 15,
              vertical: paddingY ?? 13,
            ),
          ),
        ),
        onPressed: () {
          if (disabled == false) {
            onPressed.call();
          } else {
            dPrint('Button is disabled');
          }
        },
        child: child);
  }

  Color getBgColor(AdminBtnType type) {
    switch (type) {
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
      case AdminBtnType.blue:
        return Colors.blue;
    }
  }
}
