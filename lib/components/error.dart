import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:flutter/material.dart';

enum ErrorType { withMessage, normal }

class BLError extends StatelessWidget {
  const BLError({super.key, this.type = ErrorType.normal, this.message});
  final ErrorType type;
  final String? message;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ErrorType.normal:
        return FadeIn(child: const Center(child: Icon(Icons.error, color: Colors.red)));
      case ErrorType.withMessage:
        return FadeIn(
          child: Center(
              child: Column(
            children: [
              const Icon(Icons.error, color: Colors.red),
              const SizedBox(
                height: 15,
              ),
              BLText(message ?? '')
            ],
          )),
        );
      default:
        return const BlankWidget();
    }
  }
}
