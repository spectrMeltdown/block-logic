import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

part 'generated/toast.g.dart';

@riverpod
BLToast blToast(BlToastRef ref) {
  return BLToast();
}

class BLToast {
  void showToast(
    String title, {
    BuildContext? context,
    NotifType notifType = NotifType.info,
    ToastificationStyle toastStyle = ToastificationStyle.simple,
    String? description,
    bool showProgressbar = false,
    int duration = 5,
  }) {
    const backgroundColor = Colors.black54;
    const foregroundColor = Colors.white;
    const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 16);
    const margin = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    const alignment = Alignment.topRight;
    const direction = TextDirection.ltr;
    const animationDuration = Duration(milliseconds: 300);
    const bool applyBlurEffect = true,
        closeOnClick = false,
        pauseOnHover = true,
        dragToClose = false;
    final borderRadius = BorderRadius.circular(12);
    final descriptionText = description == null
        ? null
        : RichText(text: TextSpan(text: description));
    const callbacks = ToastificationCallbacks();
    // final callbacks = ToastificationCallbacks(
    //   onTap: (toastItem) => debugPrint('Toast ${toastItem.id} tapped'),
    //   onCloseButtonTap: (toastItem) => debugPrint('Toast ${toastItem.id} close button tapped'),
    //   onAutoCompleteCompleted: (toastItem) => debugPrint('Toast ${toastItem.id} auto complete completed'),
    //   onDismissed: (toastItem) => debugPrint('Toast ${toastItem.id} dismissed'),
    // );
    switch (notifType) {
      case NotifType.error:
        toastification.show(
            context: context, // optional if you use ToastificationWrapper
            type: ToastificationType.error,
            style: toastStyle,
            autoCloseDuration: Duration(seconds: duration),
            title: Text(title),
            // you can also use RichText widget for title and description parameters
            description: descriptionText,
            alignment: alignment,
            direction: direction,
            animationDuration: animationDuration,
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            icon: const Icon(Icons.info),
            primaryColor: Colors.green,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
            margin: margin,
            borderRadius: borderRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 16,
                offset: Offset(0, 16),
                spreadRadius: 0,
              )
            ],
            showProgressBar: showProgressbar,
            closeButtonShowType: CloseButtonShowType.onHover,
            closeOnClick: closeOnClick,
            pauseOnHover: pauseOnHover,
            dragToClose: dragToClose,
            applyBlurEffect: applyBlurEffect,
            callbacks: callbacks);
        break;
      case NotifType.warning:
        toastification.show(
            context: context, // optional if you use ToastificationWrapper
            type: ToastificationType.warning,
            style: toastStyle,
            autoCloseDuration: Duration(seconds: duration),
            title: Text(title),
            // you can also use RichText widget for title and description parameters
            description: descriptionText,
            alignment: alignment,
            direction: direction,
            animationDuration: animationDuration,
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            icon: const Icon(Icons.warning),
            primaryColor: Colors.amber,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
            margin: margin,
            borderRadius: borderRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 16,
                offset: Offset(0, 16),
                spreadRadius: 0,
              )
            ],
            showProgressBar: showProgressbar,
            closeButtonShowType: CloseButtonShowType.onHover,
            closeOnClick: closeOnClick,
            pauseOnHover: pauseOnHover,
            dragToClose: dragToClose,
            applyBlurEffect: applyBlurEffect,
            callbacks: callbacks);
        break;
      case NotifType.success:
        toastification.show(
            context: context, // optional if you use ToastificationWrapper
            type: ToastificationType.success,
            style: toastStyle,
            autoCloseDuration: Duration(seconds: duration),
            title: Text(title),
            // you can also use RichText widget for title and description parameters
            description: descriptionText,
            alignment: alignment,
            direction: direction,
            animationDuration: animationDuration,
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            icon: const Icon(Icons.check),
            primaryColor: Colors.green,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
            margin: margin,
            borderRadius: borderRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 16,
                offset: Offset(0, 16),
                spreadRadius: 0,
              )
            ],
            showProgressBar: showProgressbar,
            closeButtonShowType: CloseButtonShowType.onHover,
            closeOnClick: closeOnClick,
            pauseOnHover: pauseOnHover,
            dragToClose: dragToClose,
            applyBlurEffect: applyBlurEffect,
            callbacks: callbacks);
        break;
      case NotifType.info:
        toastification.show(
            context: context, // optional if you use ToastificationWrapper
            type: ToastificationType.info,
            style: toastStyle,
            autoCloseDuration: Duration(seconds: duration),
            title: Text(title),
            // you can also use RichText widget for title and description parameters
            description: descriptionText,
            alignment: alignment,
            direction: direction,
            animationDuration: animationDuration,
            animationBuilder: (context, animation, alignment, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            icon: const Icon(Icons.info),
            primaryColor: Colors.blue,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
            margin: margin,
            borderRadius: borderRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 16,
                offset: Offset(0, 16),
                spreadRadius: 0,
              )
            ],
            showProgressBar: showProgressbar,
            closeButtonShowType: CloseButtonShowType.onHover,
            closeOnClick: closeOnClick,
            pauseOnHover: pauseOnHover,
            dragToClose: dragToClose,
            applyBlurEffect: applyBlurEffect,
            callbacks: callbacks);
        break;
    }
  }

  void dismissAllToast() {
    toastification.dismissAll();
  }
}
