import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// All auth interactions are found here
abstract class AuthService {
  /// user's uid
  static String getUserUID() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  /// user's display name
  static String getUserDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName ?? 'Guest';
  }

  /// user's email
  static String getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  /// logged in or not
  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser == null;
  }

  static Future<void> login(BuildContext context, {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> createAccount(BuildContext context,
      {required String email, required String password, required String displayName}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) return;
      await FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);
      if (!context.mounted) return;
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> resetPass(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => notifyDialog(context,
          title: 'Password reset link sent!', label: 'If this account exists, you should receive an email.'));
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static void changePass(BuildContext context, String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(password.trim());
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static void changeEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(email.trim());
      if (!context.mounted) return;
      // TODO: A verification has been sent to your new email.
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static void changeDisplayName(BuildContext context, String displayName) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(displayName.trim());
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static void deleteAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }
}
