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

  String? call(Object e, Object source, {BuildContext? context, bool handleOverlay = true}) {
    debugPrint('BLERROR: $e');
    debugPrint('OBJECT: $source');
    if (e is! FirebaseException) {
      debugPrint('Was not a FirebaseException!');
      if (context?.mounted != null && !context!.mounted) return null;
      debugPrint('Exception from: ${context?.widget.runtimeType}');
      return null;
    }
    if (context == null) handleOverlay = false;
    //state.toast.dismissAllToast();
    debugPrint('FirebaseException Code: ${e.code}');
    String? error;
    switch (e.code) {
      case 'captcha-check-failed':
        error = 'Captcha failed, Cannot proceed.';
        break;
      case 'expired-action-code':
        error = 'This code has expired. Try again.';
        break;
      case 'invalid-action-code':
        error = 'Invalid OTP code.';
        break;
      case 'quota-exceeded':
        error = 'Unknown error.';
        break;
      case 'network-request-failed':
        error = 'Network Problem!';
        break;
      case 'invalid-credential':
        error = 'Incorrect credentials';
        break;
      case 'invalid-email':
        error = 'Incorrect email.';
        break;
      case 'email-already-in-use':
        error = 'Account already exists!';
        break;
      case 'requires-recent-login':
        return null;
      case 'too-many-requests':
        error = 'Sorry, too many attempts. Try again later';
        break;
      case 'invalid-verification-code':
        error = 'Wrong code.';
        break;
      case 'invalid-verification-id':
        error = 'The verification ID was incorrect (please contact developer).';
        break;
      default:
        return null;
    }
    if (handleOverlay) {
      blShowNotifyDialog(context, title: 'Error', label: error);
    }
    return error;
  }
}

class ErrorHandlerState {
  final Toast toast;

  ErrorHandlerState._({required this.toast});
}
