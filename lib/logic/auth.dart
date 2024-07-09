import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/models.dart';
import 'package:block_logic/logic/toast.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/auth/check_acc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
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

  /// user's uid
  static Future<void> reload() async {
    return FirebaseAuth.instance.currentUser?.reload();
  }

  /// logout
  static void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    showToast('Logged out, bye!');
  }

  static Future<void> login(BuildContext context, {required String email, required String password}) async {
    try {
      /// show notification
      showToast('Logging in');

      /// signin user
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      /// return to main menu
      if (!context.mounted) return;
      Utils.pushReplace(context, const CheckAcc());

      /// show notification
      if (!context.mounted) return;
      dismissAllToast();
      showToast('Welcome back, \n ${AuthService.getDisplayName()}');
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> createAccount(BuildContext context,
      {required String email, required String password, required String displayName}) async {
    try {
      /// show notification of account creation
      showToast('Creating account ...');

      /// create account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      /// assign display name
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName.trim());

      /// send email verification
      if (!context.mounted) return;
      sendEmailVerification(context);

      /// go to email verification
      Utils.pushReplace(context, const CheckAcc());
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> sendEmailVerification(BuildContext context, {bool showNotif = true}) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      /// notify user
      if (!context.mounted) return;
      if (showNotif == true) showToast('Email verification sent!');
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> initAccountFirestore(BuildContext context) async {
    try {
      /// initialize user details
      DBService().updateUserDetails(
          UserDetails(id: AuthService.getUID(), createdAt: DateTime.now(), modifiedAt: DateTime.now()));

      /// initialize user settings
      DBService().updateUserSettings(AccountSettings(
        backgroundMusic: FlameAudio.bgm.isPlaying,
        soundEffects: false,
        loginAlerts: true,
        notifications: true,
      ));
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> resetPass(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => blShowNotifyDialog(context,
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
      showToast('A verification has been sent to your new email.');
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> changeDisplayName(BuildContext context, String displayName) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
      if (!context.mounted) return;
      Utils.pop(context);
    } on FirebaseAuthException catch (e) {
      fireErrors(context, e);
    }
  }

  static Future<void> deleteAccount(BuildContext context) async {
    try {
      /// delete account in firebase auth
      await FirebaseAuth.instance.currentUser!.delete();

      if (!context.mounted) return;
      _deleteFirestoreData(context);

      /// display info about delayed deletion
      showToast('Account Deleted');

      /// go to main menu
      Utils.pushReplace(context, const CheckAcc());
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
  static Future<String> reauth(BuildContext context, String password) async {
    AuthCredential userCred = EmailAuthProvider.credential(email: AuthService.getEmail(), password: password);
    try {
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(userCred);
      return 'success';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      if (e.code == 'too-many-requests') return e.code;
      if (!context.mounted) return 'failed';
      fireErrors(context, e);
    }
    return 'failed';
  }
}
