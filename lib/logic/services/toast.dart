// ignore_for_file: avoid_build_context_in_providers
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

part 'generated/toast.g.dart';

@riverpod
class Toast extends _$Toast {
  @override
  void build() {}

  void dismissAllToast() => toastification.dismissAll(delayForAnimation: false);

  void showToast(
    String title, {
    required NotifType type,
    String? description,
    Duration duration = const Duration(seconds: 5),
    double paddingX = 20,
  }) {
    toastification.dismissAll();
    toastification.showCustom(
        autoCloseDuration: duration,
        alignment: Alignment.topCenter,
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        builder: (context, item) {
          return Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 30),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: _getColor(type)),
                  color: _getColor(type, true)),
              child: LayoutBuilder(builder: (context, constraints) {
                final icon = Icon(
                  _getIcon(type),
                  color: _getColor(type),
                  size: 16,
                );
                const space = SizedBox(width: 10);
                final textPainter = TextPainter(
                  text: TextSpan(
                      text: title,
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout(minWidth: 0, maxWidth: constraints.maxWidth);
                if (textPainter.didExceedMaxLines) {
                  return Row(
                    children: [
                      icon,
                      space,
                      Expanded(
                          child: BLText(
                        title,
                        color: Colors.white,
                        softWrap: true,
                      ))
                    ],
                  );
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    space,
                    BLText(
                      title,
                      color: Colors.white,
                    )
                  ],
                );
              }),
            ),
          );
        });
    // context.showToast(
    //   padding: const EdgeInsets.all(16),
    //   margin: const EdgeInsets.only(top: 40),
    //   shape: const StadiumBorder(),
    //   duration: duration,
    //   backgroundColor: _getColor(type),
    //   queue: false,
    //   alignment: Alignment.topCenter,
    //   Row(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Icon(_getIcon(type), size: 16),
    //       const SizedBox(width: 10),
    //       Text(title,
    //           style: const TextStyle(
    //               color: Colors.white, fontWeight: FontWeight.bold)),
    //     ],
    //   ),
    // );
  }

  Color _getColor(NotifType type, [bool withOpacity = false]) {
    late Color color;
    switch (type) {
      case NotifType.info:
        color = Colors.blue.shade800;
        break;
      case NotifType.warning:
        color = Colors.amber.shade800;
        break;
      case NotifType.success:
        color = Colors.green.shade800;
        break;
      case NotifType.error:
        color = Colors.red.shade800;
        break;
    }
    return withOpacity ? color.withOpacity(0.3) : color;
  }

  IconData? _getIcon(NotifType type) {
    switch (type) {
      case NotifType.info:
        return FontAwesomeIcons.circleInfo;
      case NotifType.warning:
        return FontAwesomeIcons.circleExclamation;
      case NotifType.error:
        return FontAwesomeIcons.circleExclamation;
      case NotifType.success:
        return FontAwesomeIcons.circleCheck;
    }
  }
}
