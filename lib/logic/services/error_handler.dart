// ignore_for_file: avoid_build_context_in_providers
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/error_handler.g.dart';

@riverpod
class ErrorHandler extends _$ErrorHandler {
  @override
  ErrorHandlerState build() {
    final toast = ref.read(toastProvider.notifier);
    return ErrorHandlerState._(toast: toast);
  }

  String? call(Object e, {BuildContext? context, bool handleOverlay = true}) {
    if (e is! FirebaseException) {
      debugPrint('Was not a FirebaseException!');
      debugPrint(e.toString());
      if (context?.mounted != null && !context!.mounted) return null;
      debugPrint('From ${context?.widget.runtimeType}');
      return null;
    }
    if (context == null) handleOverlay = false;
    //state.toast.dismissAllToast();
    debugPrint('FirebaseException Code: ${e.code}');
    switch (e.code) {
      case 'network-request-failed':
        const String error = 'Network Problem!';
        if (handleOverlay) {
          blShowNotifyDialog(context, title: 'Error', label: error);
        }
        return error;
      case 'invalid-credential':
        const String error = 'Incorrect credentials';
        if (handleOverlay) {
          blShowNotifyDialog(context, title: 'Error', label: error);
        }
        return error;
      case 'invalid-email':
        const String error = 'Incorrect email.';
        if (handleOverlay) {
          blShowNotifyDialog(context, title: 'Error', label: error);
        }
        return error;
      case 'email-already-in-use':
        const String error = 'Account already exists!';
        if (handleOverlay) {
          blShowNotifyDialog(context, title: 'Error', label: error);
        }
        return error;
      case 'requires-recent-login':
        return null;
      case 'too-many-requests':
        const String error = 'Sorry, too many attempts. Try again later';
        if (handleOverlay) {
          blShowNotifyDialog(context, title: 'Error', label: error);
        }
        return error;
      default:
        return null;
    }
  }
}

class ErrorHandlerState {
  final Toast toast;

  ErrorHandlerState._({required this.toast});
}
