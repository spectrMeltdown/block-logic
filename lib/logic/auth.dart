import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/toast.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/main_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// All auth interactions are found here
abstract class AuthService {
  /// user's uid
  static String getUID() {
    debugPrint(FirebaseAuth.instance.currentUser?.uid);
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  /// user's display name
  static String getDisplayName() {
    return FirebaseAuth.instance.currentUser?.displayName ?? 'Guest';
  }

  /// user's email
  static String getEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  /// logged in or not
  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// email verified or not
  static bool isEmailVerified() {
    return FirebaseAuth.instance.currentUser!.emailVerified != false;
  }

  /// logout
  static void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Utils.pushReplace(context, const MainMenuScreen());
    }
  }

  static Future<void> login(BuildContext context, {required String email, required String password}) async {
    try {
      /// show notification
      showToast(context, 'Logging in');

      /// signin user
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      /// return to main menu
      if (!context.mounted) return;
      Utils.pushReplace(context, const MainMenuScreen());

      /// show notification
      if (!context.mounted) return;
      showToast(context, 'Welcome back, \n ${AuthService.getDisplayName()}');
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> createAccount(BuildContext context,
      {required String email, required String password, required String displayName}) async {
    try {
      /// show notification of account creation
      showToast(context, 'Creating account ...');

      /// create account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      if (!context.mounted) return;

      /// do some additional account initialization
      _postAccountCreation(context, displayName: displayName);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> sendEmailVerification(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      /// notify user
      if (!context.mounted) return;
      showToast(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> _postAccountCreation(BuildContext context, {required String displayName}) async {
    try {
      /// assign display name
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName.trim());

      /// send email verification
      if (!context.mounted) return;
      await sendEmailVerification(context);

      /// initialize user details in firestore
      await DBService().updateUserDetails({
        'id': AuthService.getUID(),
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'modifiedAt': Timestamp.fromDate(DateTime.now())
      });

      /// display notif
      if (!context.mounted) return;
      showToast(context, 'Account created. Welcome new player!');

      /// go to main menu
      Utils.pushReplace(context, const MainMenuScreen());
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
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName.trim());
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static void deleteAccount(BuildContext context) async {
    try {
      /// delete account in firebase auth
      await FirebaseAuth.instance.currentUser!.delete();

      if (context.mounted) {
        /// display info about delayed deletion
        showToast(context, 'Deleting account ...', description: 'This may take a while');

        /// async delete data in firestore
        _deleteFirestoreData(context);
      }

      if (!context.mounted) return;

      /// go to main menu
      Utils.pushReplace(context, const MainMenuScreen());
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static void _deleteFirestoreData(BuildContext context) async {
    try {
      /// get and delete rooms
      /// get and delete leaderboards rooms
      /// get and delete
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  /// display when the user has to reauthenticate themselves
  static void reauth(BuildContext context) async {
    try {} on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }
}
