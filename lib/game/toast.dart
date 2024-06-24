import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

showToast(BuildContext context, String title, String description, {int duration = 5}) {
  toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: ToastificationType.success,
    style: ToastificationStyle.flat,
    autoCloseDuration: Duration(seconds: duration),
    title: Text(title),
    // you can also use RichText widget for title and description parameters
    description: RichText(text: TextSpan(text: description)),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    icon: const Icon(Icons.check),
    primaryColor: Colors.green,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => debugPrint('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) => debugPrint('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) => debugPrint('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => debugPrint('Toast ${toastItem.id} dismissed'),
    ),
  );
}
